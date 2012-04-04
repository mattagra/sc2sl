# config/initializers/unprotected_attributes.rb
class ActiveRecord::Base
  #def update_attributes_with_unprotected(attributes)
  #  send :attributes=, attributes
  #  save
  #end
  #alias_method_chain :update_attributes, :unprotected
end