module TeamsHelper


  def describe_team_event(event)
    ret = ""
    case event[1]
    when 'join'
      ret = image_tag("user/small_green_arrow.png", :width => 10, :height => 9).to_s +  "New player : " + link_to(event[2].to_s, profile_path(event[2].user.login)).to_s
    when 'quit'
      ret = image_tag("user/small_red_arrow.png", :width => 10, :height => 9).to_s +  "Player left : " + link_to(event[2].to_s, profile_path(event[2].user.login)).to_s
    when "match"
      other = (event[2].teams - [event[3]]).first
      if event[2].winner == event[3]
        ret = link_to("<strong>Win</strong> against #{other.to_s}".html_safe, match_path(event[2].id))
      else
        ret = link_to("<strong>Loss</strong> against #{other.to_s}".html_safe, match_path(event[2].id))
      end
    else
      ret = event[1].to_s
    end
    ret.html_safe
  end

end
