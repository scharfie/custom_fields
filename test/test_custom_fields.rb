require 'minitest_helper'

class User < ActiveRecord::Base
  include CustomFields
  custom_field :hometown
end

class TestCustomFields < Minitest::Test
  def test_user_should_have_custom_field_hometown
    assert User.custom_fields.include?(:hometown)
  end

  def test_get_custom_field_store_should_build_store
    user = User.new
    assert_instance_of CustomFieldStore, user.custom_field_store
  end

  def test_should_set_and_get_custom_field_low_level
    user = User.new

    user.custom_field_store.write_custom_field :hometown, "Gotham"

    assert_equal "Gotham", user.custom_field_store.read_custom_field(:hometown)
  end

  def test_should_set_and_get_custom_field_through_custom_accessors
    user = User.new

    user.hometown = "Gotham"

    assert_equal "Gotham", user.hometown
    assert_equal "Gotham", user.custom_field_store.custom_fields[:hometown]
    assert_equal "Gotham", user.custom_field_store.read_custom_field(:hometown)
  end

end
