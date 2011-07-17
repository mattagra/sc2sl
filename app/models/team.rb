class Team < ActiveRecord::Base

  #Associations
  belongs_to :country
  belongs_to :user
  has_and_belongs_to_many :seasons
  has_many :players

  #Validations
  validates :name, :presence => true
  validates :county, :presence => true
  validates :short_name, :presence => true

  def matches
    Match.where("team0_id = ? or team1_id = ?", self.id, self.id)
  end

  

  has_attached_file :photo,
    {:styles => {
      :large => "180x180!",
      :normal => "100x100!",
      :thumb => "32x32!"
    }, :url => "/images/:class/:attachment/:id/:style_:basename.:extension", :path => ":rails_root/public:url"}

  alias :coach :user

    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Team.to_s}'"


  def to_s
    self.name
  end

  def slug
    self.name.gsub(/\s/,'_')
  end

  def self.deslug(name)
    name.gsub(/\_/,' ')
  end
  


end
