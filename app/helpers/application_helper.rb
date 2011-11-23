module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  def show_flash
    [:notice, :warning, :message].collect do |key|
      content_tag(:div, flash[key], :class => "flash flash_#{key}") unless flash[key].blank?
    end.join
  end
  
  def american_time(time, year = true)
    if year
      time.strftime("%b %d, %Y %H:%M %Z")
    else
      time.strftime("%b %d %H:%M %Z")
    end
  end

  def american_date(time, year = true)
    if year
      time.strftime("%b %d, %Y")
    else
      time.strftime("%b %d")
    end
  end



  def tags_to_links(tags)
    result = []
    tags.each do |tag|
      result << link_to(tag.name, articles_path(:tag => tag.name))
    end
    result.join(" ")
  end



  def race_icon_url(race)
    case race
    when "protoss"
      "/css/images/races/jaune.jpg"
    when "zerg"
      "/css/images/races/mauve.jpg"
    when "terran"
      "/css/images/races/rouge.jpg"
    else
      "/css/images/races/random.jpg"
    end
  end

  def view_article_path(article, page = 0)
    zone = ActiveSupport::TimeZone.new("Paris")
    time = article.created_at.in_time_zone(zone)
    if page.to_i > 0
      named_article_path(:year => time.year, :month => time.strftime("%m"), :day => time.strftime("%d"), :url => article.url, :page => page)
    else
      named_article_path(:year => time.year, :month => time.strftime("%m"), :day => time.strftime("%d"), :url => article.url)
    end
  end

  def view_article_url(article, page = 0)
    zone = ActiveSupport::TimeZone.new("Paris")
    time = article.created_at.in_time_zone(zone)
    if page.to_i > 0
      named_article_url(:year => time.year, :month => time.strftime("%m"), :day => time.strftime("%d"), :url => article.url)
    else
      named_article_url(:year => time.year, :month => time.strftime("%m"), :day => time.strftime("%d"), :url => article.url, :page => page)
    end
  end

  def view_comment_path(comment)
    case comment.external_type
    when "Article"
      view_article_path(comment.external_object, comment.external_page)
    end
  end


  def sanitize_comments(comments)
    comments = comments ? comments.to_str : ''
    comments = comments.dup if comments.frozen?
    comments.gsub!(/\r\n?/, "\n")
    comments.gsub!(/\n/, "<br />")
    Sanitize.clean(comments, Sanitize::Config::RELAXED)
  end


  def paginate_links(per_page, current, total, url, params = {})
    current = current.to_i || 1
    outside_width = 1
    inside_width = 1
    max_page = ([(total.to_f / per_page.to_f).ceil,1].max).to_i
    final_pages = []
    1.upto(max_page) do |page|
      if page == current
        final_pages << page
      elsif page < outside_width or page >= max_page - outside_width
        final_pages << page
      elsif (current - page).abs <= inside_width
        final_pages << page
      else
      end
    end
    boxes = []
    left =  link_to(image_tag("/css/images/paginationl.gif"), url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url, :page).merge(:page => "#{[current, 1].max}").collect{|k,v| "#{k}=#{v}"}.join("&")))) + " "
    
    c = 0
    final_pages.each do |page|
      if (c - page).abs > 1
        boxes << "..."
        boxes <<  link_to_unless_current(page.to_s, url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => page)).collect{|k,v| "#{k}=#{v}"}.join("&"))).to_s
      else
	    if page == 1
		  boxes << link_to_unless_current(page.to_s, request.url).to_s
		else
          boxes << link_to_unless_current(page.to_s, url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => page)).collect{|k,v| "#{k}=#{v}"}.join("&"))).to_s
		end
      end
      c = page
    end
    right =  "  " + link_to(image_tag("/css/images/paginationr.gif"),url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => "#{[current + 1, max_page].min}")).collect{|k,v| "#{k}=#{v}"}.join("&")))
    return (left.html_safe + boxes.join(" | ").html_safe + right.html_safe).html_safe # + "per_page: #{per_page}, current: #{current}, total: #{total}"
  end

  def grayscale_banner_link(banner, path)
    link_to(image_tag(banner.url(:normal_gray), :border => "0", :onmouseover => "this.src='#{banner.url(:normal)}'", :onmouseout => "this.src='#{banner.url(:normal_gray)}'"), path)
    #("<div style='height: 129px;'>" +
    #    link_to(image_tag(banner.url(:normal), :class => "img_colorscale"), path) +
    #    link_to(image_tag(banner.url(:normal_gray), :class => "img_grayscale"), path) + "</div>").html_safe
  end


  def rating_star_image(rating)
    if rating > 4.5
      "/css/images/last-replays/goldstar.png"
    elsif rating > 3.5
      "/css/images/last-replays/silverstar.png"
    elsif rating > 0
      "/css/images/last-replays/bronzestar.png"
    else
      "/css/images/last-replays/emptystar.png"
    end
  end


  def describe_player_event(event)
    ret = ""
    case event[1]
    when 'join'
      ret = "<img src='/css/images/user/small_green_arrow.png' alt='' width='10' height='9' /> Joined #{link_to(event[2].team.to_s, team_path(event[2].team.slug))}"
    when 'quit'
      ret = "<img src='/css/images/user/small_red_arrow.png' alt='' width='10' height='9' /> Left #{link_to(event[2].team.to_s, team_path(event[2].team.slug))}"
    when "game"
      other = (event[2].players - [event[3]]).first
      if event[2].winning_player == event[3]
        ret = "<strong>Win</strong> against #{link_to other.to_s, profile_path(other.to_s)}"
      else
        ret = "<strong>Loss</strong> against #{link_to other.to_s, profile_path(other.to_s)}"
      end
    else
      ret = event[1].to_s
    end
    ret.html_safe
  end
  
  
  def random_ad(style)
    ad = Advertisement.of_type(style).random_ad.take(1).first
	if ad
	  link_to(image_tag(ad.photo.url(style), :alt => ad.title, :width => Advertisement::AD_TYPES[style][:width], :height => Advertisement::AD_TYPES[style][:height] ) ,ad.url)
	else
	  ""
	end
  end

  

  

end
