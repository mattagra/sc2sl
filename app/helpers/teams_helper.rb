module TeamsHelper


  def describe_team_event(event)
    ret = ""
    case event[1]
    when 'join'
      ret = "<img src='/css/images/user/small_green_arrow.png' alt='' width='10' height='9' /> New player : #{link_to(event[2].to_s, profile_path(event[2].user.login))}"
    when 'quit'
      ret = "<img src='/css/images/user/small_red_arrow.png' alt='' width='10' height='9' /> Player left : #{link_to(event[2].to_s, profile_path(event[2].user.login))}"
    when "match"
      other = (event[2].teams - [event[3]]).first
      if event[2].winner == event[3]
        ret = "<strong>Win</strong> against #{link_to other.to_s, team_path(other.slug)}"
      else
        ret = "<strong>Loss</strong> against #{link_to other.to_s, team_path(other.slug)}"
      end
    else
      ret = event[1].to_s
    end
    ret.html_safe
  end

end
