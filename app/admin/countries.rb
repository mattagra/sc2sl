ActiveAdmin.register Country do
  index do
    column "Name" do |country|
      link_to country.name, admin_country_path(country)
    end
    column :short
  end
end
