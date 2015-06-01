class CustomFieldStore < ActiveRecord::Base
  self.table_name = "custom_field_store"
  belongs_to :owner, :polymorphic => true

  serialize :custom_fields, JSON

  def custom_fields
    value = self[:custom_fields]
    
    case value
    when HashWithIndifferentAccess
      return value
    when Hash
      value = value.with_indifferent_access
    else
      value = HashWithIndifferentAccess.new
    end

    self[:custom_fields] = value
  end
end
