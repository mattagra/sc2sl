module PlayersHelper

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
        ret = "<strong>Win</strong> against #{link_to other.to_s, player_path(other.to_s)}"
      else
        ret = "<strong>Loss</strong> against #{link_to other.to_s, player_path(other.to_s)}"
      end
    else
      ret = event[1].to_s
    end
    ret.html_safe
  end

end
