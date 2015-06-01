require "custom_fields/version"
require 'custom_field_store'

module CustomFields
  module ClassMethods
    attr_accessor :custom_fields

    def custom_fields
      @custom_fields ||= []
    end

    # create new custom field
    def custom_field(name)
      self.custom_fields << name.to_sym

      define_method(name) do
        custom_fields[name]
      end

      define_method(:"#{name}=") do |value|
        custom_fields[name] = value
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
    base.has_one :custom_field_store, :as => :owner, :dependent => :destroy
  end

  # returns the custom field store associated object,
  # ensuring that one exists
  def custom_field_store
    super || self.build_custom_field_store
  end

  # access custom fields through the custom field store
  def custom_fields
    custom_field_store.custom_fields
  end
end
