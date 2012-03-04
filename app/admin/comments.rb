ActiveAdmin.register Comment, :as => "CommentsSite" do
  scope :all, :default => true
  Comment::EXTERNAL_TYPES.each do |e|
    scope e.to_sym
  end

end
