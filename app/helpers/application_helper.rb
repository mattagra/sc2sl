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
      "/css/images/races/rogue.jpg"
    else
      "/css/images/races/random.jpg"
    end
  end

  def view_article_path(article)
    named_article_path(:year => article.created_at.year, :month => article.created_at.strftime("%m"), :day => article.created_at.strftime("%d"), :url => article.url)
  end

  def sanitize_comments(comments)
    comments = comments ? comments.to_str : ''
    comments = comments.dup if comments.frozen?
    comments.gsub!(/\r\n?/, "\n")
    comments.gsub!(/\n/, "<br />")
    Sanitize.clean(comments, Sanitize::Config::RELAXED)
  end

  

  

end
