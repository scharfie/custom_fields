require 'active_record'
require "custom_fields/version"
require 'custom_field_store'

module CustomFields
  module ClassMethods
    def custom_fields
      @custom_fields ||= []
    end

    # create new custom field
    def custom_field(name)
      self.custom_fields << name.to_sym

      define_method(name) do
        custom_field_store.read_custom_field(name)
      end

      define_method(:"#{name}=") do |value|
        custom_field_store.write_custom_field(name, value)
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
    base.has_one :custom_field_store, :as => :owner, :dependent => :destroy,
      :inverse_of => :owner,
      :autosave => false

    base.after_save :persist_custom_fields
  end

  # returns the custom field store associated object,
  # ensuring that one exists
  def custom_field_store
    super || build_custom_field_store(:owner => self)
  end

  def persist_custom_fields
    store = custom_field_store
    store.save if store.needs_saved?
  end

  # access custom fields through the custom field store
  def custom_fields
    custom_field_store.custom_fields
  end
end
