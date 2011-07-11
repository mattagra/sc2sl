module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper
  
  def american_time(time)
    time.strftime("%m-%d-%Y %H:%M")
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


  def paginate_links(per_page, current, total, url)
    current = current.to_i
    outside_width = 1
    inside_width = 1
    max_page = ([(total.to_f / per_page.to_f).ceil - 1,0].max).to_i
    final_pages = []
    0.upto(max_page) do |page|
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
    boxes << link_to_unless_current("<< Previous", url_for(url+"?page=#{[current - 1, 0].max}"))
    
    c = 0
    final_pages.each do |page|
      if (c - page).abs > 1
        boxes << " | ..."
        boxes << " | " + link_to_unless_current(page.to_s, url_for(url+"?page=#{page}"))
      else
        boxes << " | " + link_to_unless_current(page.to_s, url_for(url+"?page=#{page}"))
      end
      c = page
    end
    boxes << " | " + link_to_unless_current("Next >>", url_for(url+"?page=#{[current + 1, max_page].min}"))
    return sanitize(boxes.join("")) # + "per_page: #{per_page}, current: #{current}, total: #{total}"
  end

  

  

end
