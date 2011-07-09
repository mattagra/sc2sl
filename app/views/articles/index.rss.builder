xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "SC2SL News"
    xml.description "Get the latest news about the Starcraft 2 Survivor League"
    xml.link articles_url

    for article in @articles
      xml.item do
        xml.title article.title
        xml.description article.description
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link view_article_url(article)
        xml.guid view_article_url(article)
      end
    end
  end
end