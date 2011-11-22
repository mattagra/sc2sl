class Array
  # Chooses a random array element from the receiver based on the weights
  # provided. If _weights_ is nil, then each element is weighed equally.
  #
  #   [1,2,3].random          #=> 2
  #   [1,2,3].random          #=> 1
  #   [1,2,3].random          #=> 3
  #
  # If _weights_ is an array, then each element of the receiver gets its
  # weight from the corresponding element of _weights_. Notice that it
  # favors the element with the highest weight.
  #
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 1
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 2
  #   [1,2,3].random([1,4,1]) #=> 3
  #
  # If _weights_ is a symbol, the weight array is constructed by calling
  # the appropriate method on each array element in turn. Notice that
  # it favors the longer word when using :length.
  #
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "dog"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "hippopotamus"
  #   ['dog', 'cat', 'hippopotamus'].random(:length) #=> "cat"
  def random(weights=nil)
    return random(map {|n| n.send(weights)}) if weights.is_a? Symbol

    weights ||= Array.new(length, 1.0)
    total = weights.inject(0.0) {|t,w| t+w}
    point = rand * total

    zip(weights).each do |n,w|
      return n if w >= point
      point -= w
    end
  end

  # Generates a permutation of the receiver based on _weights_ as in
  # Array#random. Notice that it favors the element with the highest
  # weight.
  #
  #   [1,2,3].randomize           #=> [2,1,3]
  #   [1,2,3].randomize           #=> [1,3,2]
  #   [1,2,3].randomize([1,4,1])  #=> [2,1,3]
  #   [1,2,3].randomize([1,4,1])  #=> [2,3,1]
  #   [1,2,3].randomize([1,4,1])  #=> [1,2,3]
  #   [1,2,3].randomize([1,4,1])  #=> [2,3,1]
  #   [1,2,3].randomize([1,4,1])  #=> [3,2,1]
  #   [1,2,3].randomize([1,4,1])  #=> [2,1,3]
  def randomize(weights=nil)
    return randomize(map {|n| n.send(weights)}) if weights.is_a? Symbol

    weights = weights.nil? ? Array.new(length, 1.0) : weights.dup

    # pick out elements until there are none left
    list, result = self.dup, []
    until list.empty?
      # pick an element
      result << list.random(weights)
      # remove the element from the temporary list and its weight
      weights.delete_at(list.index(result.last))
      list.delete result.last
    end

    result
  end
end


class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user, :current_admin, :current_moderator, :current_super_admin, :require_unbanned_user
  #filter_parameter_logging :password, :password_confirmation

  before_filter :set_timezone
  before_filter :mailer_set_url_options
  before_filter :tag_cloud
  before_filter :articles
  before_filter :live_match
  before_filter :meta_tags
  before_filter :current_voting
  before_filter :set_date_object_and_find_matches

  #before_filter :require_http_auth
  
  protected
  def require_http_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == "p6e" && password == "p6esc2"
    end
  end


  private

  def set_date_object_and_find_matches
    @today = Date.today
	@calendar_date = params[:month] ? Date.new(params[:year].to_i,params[:month].to_i, 1) : Date.today
	@layout_matches = Match.where(:scheduled_at => (@calendar_date.beginning_of_month - 1)..(@calendar_date.end_of_month + 1)).includes([:team0, :team1])
  end


  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def articles
    @frontpage_articles = Article.order("articles.id desc").published.limit(8)
  end
  
  def live_match
    @live_match = Match.where(:live => true).order("matches.scheduled_at desc").limit(1).first || Match.where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at asc").limit(1).first
    @upcoming_matches =  Match.where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at asc").limit(4)

  end

  def current_voting
    @current_vote_event = VoteEvent.last
  end


  def tag_cloud
    @tags = Article.tag_counts_on(:tags)
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_moderator
    if current_user and current_user.is_moderator?
      return current_user
    else
      return nil
    end
  end

  def current_admin
    if current_user and current_user.is_admin?
      return current_user
    else
      return nil
    end
  end

  def current_super_admin
    if current_user and current_user.is_super_admin?
      return current_user
    else
      return nil
    end
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def authenticate_super_admin!
    unless current_super_admin
      raise ActionController::RoutingError.new('Not Found')
    end
  end



  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    store_location
    flash[:notice] = "You do not have access to this page"
    render :file => "public/404.html", :status => 404, :layout => false
    return false
  end

  def meta_tags
    @layout_page = ""
    @layout_subpage = ""
    @description = "Welcome to SC2 Survivor League. The top international league that involves you, the fan."
    @keywords = ["Starcraft 2", "sc2", "Survivor League", "p6e", "protoss", "zerg", "terran"]
  end

  def set_timezone
    Time.zone = (current_user.time_zone if current_user) || Sc2sl::Application.config.time_zone
  end


end

