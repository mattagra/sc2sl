module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  def show_flash
    [:notice, :warning, :message].collect do |key|
      content_tag(:div, flash[key], :class => "flash flash_#{key}") unless flash[key].blank?
    end.join
  end
  
  def american_time(time, year = true)
    if year
      time.strftime("%m-%d-%Y %H:%M")
    else
      time.strftime("%m-%d %H:%M")
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

  def view_article_path(article)
    named_article_path(:year => article.created_at.year, :month => article.created_at.strftime("%m"), :day => article.created_at.strftime("%d"), :url => article.url)
  end

  def view_article_url(article)
    named_article_url(:year => article.created_at.year, :month => article.created_at.strftime("%m"), :day => article.created_at.strftime("%d"), :url => article.url)
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
    boxes << link_to_unless_current("<< Previous", url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => "#{[current, 1].max}").collect{|k,v| "#{k}=#{v}"}.join("&"))))
    
    c = 0
    final_pages.each do |page|
      if (c - page).abs > 1
        boxes << " | ..."
        boxes << " | " + link_to_unless_current(page.to_s, url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => page)).collect{|k,v| "#{k}=#{v}"}.join("&")))
      else
        boxes << " | " + link_to_unless_current(page.to_s, url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => page)).collect{|k,v| "#{k}=#{v}"}.join("&")))
      end
      c = page
    end
    boxes << " | " + link_to_unless_current("Next >>",url_for(url+"?"+(request.params.except(:action, :controller, :model_name, :year, :month, :day, :url).merge(:page => "#{[current + 1, max_page].min}")).collect{|k,v| "#{k}=#{v}"}.join("&")))
    return sanitize(boxes.join("")) # + "per_page: #{per_page}, current: #{current}, total: #{total}"
  end

  def grayscale_banner_link(banner, path)
    ("<div style='height: 129px;'>" +
        link_to(image_tag(banner.url(:normal), :class => "img_colorscale"), path) +
        link_to(image_tag(banner.url(:normal_gray), :class => "img_grayscale"), path) + "</div>").html_safe
  end

  

  

end
