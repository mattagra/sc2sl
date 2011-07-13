class Game < ActiveRecord::Base
  belongs_to :map
  belongs_to :match
  belongs_to :player0, :class_name => "Player"
  belongs_to :player1, :class_name => "Player"

  has_attached_file :replay, {:url => "/images/:class/:attachment/:id/:customname.:extension", :path => ":rails_root/public:url"}
  has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Game.to_s}'"

  ajaxful_rateable :stars => 5

  def customname
    (self.player0.team.short_name + "." + self.player0.user.login + " vs " + self.player1.team.short_name + "."  + self.player1.user.login + " on " + self.map.name).gsub(/\s/,"_")
  end

  before_create :set_defaults

  def set_defaults
    self.downloads = 0
  end

  def result_s
    case result
    when 0
      player0.team.short_name
    when 1
      player1.team.short_name
    else
      ""
    end
  end

end
