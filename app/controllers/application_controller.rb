
class ApplicationController < ActionController::Base
  include UrlHelper
  protect_from_forgery
  helper :all
  helper_method :current_user_session, :current_user, :current_admin, :current_moderator, :current_super_admin, :require_unbanned_user
  #filter_parameter_logging :password, :password_confirmation

  before_filter :set_timezone
  before_filter :mailer_set_url_options
  #before_filter :tag_cloud
  before_filter :articles
  before_filter :live_match
  before_filter :meta_tags
  before_filter :current_voting
  before_filter :set_date_object_and_find_matches
  before_filter :set_locale
  
  unless Rails.application.config.consider_all_requests_local
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::RoutingError, :with => :render_not_found
  rescue_from ActionController::UnknownController, :with => :render_not_found
  rescue_from ActionController::UnknownAction, :with => :render_not_found
  end
  
  
  def render_not_found
    respond_to do |type| 
      type.html { render :template => "errors/error_404", :status => 404, :layout => 'application' } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    true
  end


  
  
  
  
  protected
  def require_http_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == "p6e" && password == "p6esc2"
    end
  end


  private
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def default_url_options(options = {})
    unless I18n.locale == :en
      {:locale => I18n.locale}
    else
      {:locale => nil}
    end
end

  def set_date_object_and_find_matches
    @today = Date.today
	@calendar_date = (params[:calendar_month] and params[:calendar_year]) ? Date.new(params[:calendar_year].to_i,params[:calendar_month].to_i, 1) : Date.today
	@layout_matches = Match.where(:scheduled_at => (@calendar_date.beginning_of_month - 1)..(@calendar_date.end_of_month + 1)).includes([:team0, :team1])
  end


  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def articles
      @frontpage_articles = Article.newest.published.limit(8)
  end
  
  def live_match
      @live_match = Match.where(:live => true).order("matches.scheduled_at desc").first() || Match.where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at asc").first()
      @upcoming_matches =  Match.where("matches.scheduled_at > ?", Time.now).order("matches.scheduled_at asc").limit(4)
  end

  def current_voting
      @current_vote_event = VoteEvent.last
  end


  def tag_cloud
    @tags = Article.tag_counts_on(:tags)
  end


  #def current_user_session
  #  return @current_user_session if defined?(@current_user_session)
  #  @current_user_session = UserSession.find
  #end
  #
  #def current_user
  #  return @current_user if defined?(@current_user)
  #  @current_user = current_user_session && current_user_session.record
  #end
  #
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
  #
  #def require_user
  #  unless current_user
  #    store_location
  #    flash[:notice] = "You must be logged in to access this page"
  #    redirect_to new_user_session_url
  #    return false
  #  end
  #end
  #
  #def require_no_user
  #  if current_user
  #    store_location
  #    flash[:notice] = "You must be logged out to access this page"
  #    redirect_to account_url
  #    return false
  #  end
  #end
  #
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
    Time.zone =  (current_user.time_zone if current_user and !current_user.time_zone.blank?) || Sc2sl::Application.config.time_zone
  end


end

