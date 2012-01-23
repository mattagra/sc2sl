class SiteController < ApplicationController

  before_filter :current_user
  
  caches_action :index, :layout => false, :expires_in => 15.seconds
  caches_action :terms, :layout => false
  caches_action :sitemap, :expires_in => 30.minutes
  
  def index
    @article = Article.latest.featured.published.first
    @games = Game.where("games.result is not null").paginated(1, 10).includes({:player0 => :team, :player1 => :team})
    
    @season = Season.where(:published => true).limit(1)
  end

  def finish_registration

  end

  def finish_activation
    
  end

  #For the future!!!!
  #def panda
  #  require "RMagick"
  #  include Magick
  #  def lolcat
  #    img = ImageList.new("public/images/caption/panda.png")
  #    txt = Draw.new
  #    img.annotate(txt, 0,0,0,0, "In ur Railz, annotatin ur picz."){
  #      txt.gravity = Magick::SouthGravity
  #      txt.pointsize = 25
  #      txt.stroke = '#000000'
  #      txt.fill = '#ffffff'
  #      txt.font_weight = Magick::BoldWeight
  #    }
  #    img.format = 'png'
  #    send_data img.to_blob, :stream => 'false', :filename => 'test.png', :type => 'image/png', :disposition => 'inline'
  #  end
  #end

  def terms
    render :layout => false
    
  end



  def sitemap
    @static_pages = ["live", "terms", "faq", "", "about", "contact", "privacy", "partner"]
    @articles = Article.all
    @matches = Match.all
    @teams = Team.all
    @players = Player.all
    respond_to do |format|
      format.xml
    end
  end



end
