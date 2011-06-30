module ArticlesHelper

  def tags_to_links(tags)
    tags = tags.split(" ")
    result = []
    tags.each do |tag|
      result << link_to(tag, articles_path(:tag => tag))
    end
    result.join(" ")
  end

end
