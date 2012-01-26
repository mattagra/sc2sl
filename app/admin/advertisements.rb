ActiveAdmin.register Advertisement do
  
  filter :title
  filter :url
  filter :ad_type, :as => :check_boxes, :collection => Advertisement::AD_TYPES.keys

  index do
    column :title
	column :url
	column :ad_type
    column "Photo" do |advertisement|
      image_tag(advertisement.photo.url(advertisement.ad_type), :width => 25, :height => 25)
    end
    column :is_html_ad?
	column :weight
    column :updated_at
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :title
	  f.input :url
	  f.input :ad_type, :as => :select, :collection => Advertisement::AD_TYPES.keys
      f.input :photo, :label => "Photo (horizontal => 570x92, vertical => 120x600)"
      f.input :html_text
	  f.input :weight
    end
    f.buttons

  end
  
  show do |advertisement|
    panel "Advertisement Details" do
      attributes_table_for advertisement do
        row("Title") {advertisement.title}
		row("Url") {advertisement.url}
		row("Ad Type") {advertisement.ad_type}
        row("Image") {image_tag advertisement.photo.url(advertisement.ad_type)}
        row("Html text") {advertisement.html_text}
      end
    end
    active_admin_comments
  end
  
  controller do
    cache_sweeper :advertisement_sweeper
    
  end


  
end
