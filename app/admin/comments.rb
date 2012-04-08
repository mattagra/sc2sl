ActiveAdmin.register Comment, :as => "User Comments" do
  scope :all, :default => true
  Comment::EXTERNAL_TYPES.each do |e|
    scope e.to_sym
  end
  
  
    form do |f|
    f.inputs "Details" do
      f.input :description
	  f.input :locked
    end

    
    f.buttons
    
  end

end
