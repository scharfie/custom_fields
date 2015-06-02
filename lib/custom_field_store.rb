class CustomFieldStore < ActiveRecord::Base
  class Serializer
    def self.load(raw)
      return HashWithIndifferentAccess.new if raw.blank?
      JSON.parse(raw, :object_class => HashWithIndifferentAccess)
    end

    def self.dump(data)
      JSON.generate(data)
    end
  end

  self.table_name = "custom_field_store"

  belongs_to :owner, :polymorphic => true,
    :inverse_of => :custom_field_store

  serialize :custom_fields, Serializer

  def custom_fields
    value = read_attribute(:custom_fields)
    
    case value
    when HashWithIndifferentAccess
      return value
    when Hash
      value = value.with_indifferent_access
    else
      value = HashWithIndifferentAccess.new
    end

    write_attribute(:custom_fields, value)
  end

  def read_custom_field(name)
    custom_fields[name]
  end

  def write_custom_field(name, value)
    if custom_fields[name] != value
      attribute_will_change! :custom_fields
    end

    custom_fields[name] = value
  end

  def needs_saved?
    return false if new_record? && custom_fields.empty?
    return changed?
  end
end
