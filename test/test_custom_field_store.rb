require 'minitest_helper'

class TestCustomFieldStore < Minitest::Test
  def test_custom_field_store_custom_fields
    store = CustomFieldStore.new
    assert_instance_of HashWithIndifferentAccess, store.custom_fields
  end

  def test_custom_field_store
    store = CustomFieldStore.new
    store.write_custom_field :hometown, "Gotham"
    assert_equal "Gotham", store.read_custom_field(:hometown)
  end
end
