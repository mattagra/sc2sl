xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @static_pages.each do |static_page|
    xml.url do
      xml.loc "http://www.sc2sl.com/" + static_page
      xml.priority 1.0
    end
  end


  @articles.each do |article|
    xml.url do
      xml.loc view_article_url(article)
      xml.lastmod article.updated_at.to_date
      xml.priority 0.9
    end
  end

  @matches.each do |match|
    xml.url do
      xml.loc match_url(match)
      xml.lastmod match.updated_at.to_date
      xml.priority 0.9
    end
  end

  @teams.each do |team|
    xml.url do
      xml.loc team_url(team)
      xml.lastmod team.updated_at.to_date
      xml.priority 0.9
    end
  end

  @players.each do |player|
    xml.url do
      xml.loc player_url(player)
      xml.lastmod player.updated_at.to_date
      xml.priority 0.9
    end
  end

end