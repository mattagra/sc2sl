ActiveAdmin.register Map do
  
  filter :name

  index do
    column :name
    column "Photo" do |map|
      image_tag map.photo.url(:thumb)
    end
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :photo
    end
    f.inputs "Content" do
      f.input :description
    end
    f.buttons

  end
  
  show :title => :name do |map|
    panel "Map Details" do
      attributes_table_for map do
        row("Name") {map.name}
        row("Image") {image_tag map.photo.url(:thumb)}
        row("Description") {map.description}
      end
    end
    active_admin_comments
  end


  
end
