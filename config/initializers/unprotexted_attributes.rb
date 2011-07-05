# config/initializers/unprotected_attributes.rb
class ActiveRecord::Base
  def update_attributes_with_unprotected(attributes, guard_protected_attributes = true)
    send :attributes=, attributes, guard_protected_attributes
    save
  end
  alias_method_chain :update_attributes, :unprotected
end