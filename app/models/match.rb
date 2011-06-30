class Match < ActiveRecord::Base
    has_many :comments, :foreign_key => :external_id, :conditions => "external_type = '#{Match.to_s}'"

end
