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

  def test_updating_custom_field_should_touch_owner
    time = Time.new(2000, 1, 1)
    user = User.create

    user.created_at = time
    user.updated_at = time
    user.save

    assert_equal time, user.created_at
    assert_equal time, user.updated_at

    user.custom_field_store.write_custom_field :hometown, "Gotham"
    user.custom_field_store.save

    refute_equal time, user.updated_at
  end
end
