module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper


  def cms_snippet_locale(id, locale = I18n.locale)
    cms_snippet_content(id + ("_" + locale_path_unless_default(locale) unless locale_path_unless_default(locale).blank? ).to_s)
  end

  def path_locale(path, locale = I18n.locale)
    (("/" + locale_path_unless_default(locale).to_s) unless locale_path_unless_default(locale).blank? ).to_s + path
  end



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
  
  def american_time_only(time, zone = nil)
    if zone
	  time.in_time_zone(zone).strftime("%a %H:%M %Z")
	else
      time.strftime("%a %H:%M %Z")
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
      image_path "races/jaune.jpg"
    when "zerg"
      image_path "races/mauve.jpg"
    when "terran"
      image_path "races/rouge.jpg"
    else
      image_path "races/random.jpg"
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
    unless page.to_i > 0
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
    outside_width = 2
    inside_width = 2
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
    left =  link_to("Prev", url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url, :page, :id).merge(:page => "#{[current - 1, 1].max}").collect{|k,v| "#{k}=#{v}"}.join("&"))), :class => "link") + " "
    
    c = 0
    final_pages.each do |page|
      if (c - page).abs > 1
        boxes << "..."
        boxes <<  link_to(page.to_s, url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url, :page, :id).merge(:page => page)).collect{|k,v| "#{k}=#{v}"}.join("&")), {:class => ((page == current) ? "current_link": "link")}).to_s
      else
          boxes << link_to(page.to_s, url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url, :page, :id).merge(:page => page)).collect{|k,v| "#{k}=#{v}"}.join("&")), {:class => ((page == current) ? "current_link": "link")}  ).to_s
      end
      c = page
    end
    right =  "  " + link_to("Next",url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url, :page, :id).merge(:page => "#{[current + 1, max_page].min}")).collect{|k,v| "#{k}=#{v}"}.join("&")), :class => "link")
    return (left.html_safe + boxes.join(" ").html_safe + right.html_safe).html_safe # + "per_page: #{per_page}, current: #{current}, total: #{total}"
  end

  def grayscale_banner_link(banner, path)
    link_to(image_tag(banner.url(:normal_gray), :border => "0", :onmouseover => "this.src='#{banner.url(:normal)}'", :onmouseout => "this.src='#{banner.url(:normal_gray)}'"), path)

  end


  def rating_star_image(rating)
    if rating > 4.5
      image_path "last-replays/goldstar.png"
    elsif rating > 3.5
      image_path "last-replays/silverstar.png"
    elsif rating > 0
      image_path "last-replays/bronzestar.png"
    else
      image_path "last-replays/emptystar.png"
    end
  end


  def describe_player_event(event)
    ret = ""
    case event[1]
    when 'join'
      ret = image_tag("user/small_green_arrow.png", :height => 9, :width => 10).to_s + "Joined " +link_to(event[2].team.to_s, team_path(event[2].team.slug)).to_s
    when 'quit'
      ret = image_tag("user/small_red_arrow.png", :height => 9, :width => 10).to_s + "Left " + link_to(event[2].team.to_s, team_path(event[2].team.slug)).to_s
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
    cache = ActiveSupport::Cache::MemCacheStore.new(:expires_in => 2.minutes)
    ads = cache.fetch("advertisments_#{style}") do
      Advertisement.of_type(style).to_a
    end
    #ads = Advertisement.of_type(style).to_a
    ad = ads.random(:weight)
	if ad
      if ad.photo.exists?
	    link_to(image_tag(ad.photo.url(style), :alt => ad.title, :width => Advertisement::AD_TYPES[style][:width], :height => Advertisement::AD_TYPES[style][:height] ) ,ad.url, :target => "_blank")
      elsif ad.is_html_ad?
        ad.html_text.html_safe
      else
        "ADVERTISEMENT ERROR"
      end      
	else
	  "ADVERTISEMENT NOT FOUND"
	end
  end
  
  
  def describe_round(round, max_rounds)
  round += 1
    if round == max_rounds
      "Grand Final"
    elsif round + 1 == max_rounds
      "Semi Finals"
    else
      "Round of "  + (2**(max_rounds - round + 1)).to_s
    end
  end


  def flag_icon(country)
    "<i class='flag flags-#{country}'></i>".html_safe
  end



  private

  def locale_path_unless_default(locale, default = :en)
    (I18n.locale unless I18n.locale == default).to_s
  end


  

end
