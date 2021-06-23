require 'minitest_helper'

class User < ActiveRecord::Base
  include CustomFields
  custom_field :hometown
end

module DifferenceAssertions
  def assert_difference(expression, *args, &block)
    expressions =
      if expression.is_a?(Hash)
        message = args[0]
        expression
      else
        difference = args[0] || 1
        message = args[1]
        Hash[Array(expression).map { |e| [e, difference] }]
      end

    exps = expressions.keys.map { |e|
      e.respond_to?(:call) ? e : lambda { eval(e, block.binding) }
    }
    before = exps.map(&:call)

    retval = yield

    expressions.zip(exps, before) do |(code, diff), exp, before_value|
      error  = "#{code.inspect} didn't change by #{diff}"
      error  = "#{message}.\n#{error}" if message
      assert_equal(before_value + diff, exp.call, error)
    end

    retval
  end

  def assert_no_difference(expression, message = nil, &block)
    assert_difference expression, 0, message, &block
  end
end

class TestCustomFields < Minitest::Test
  include DifferenceAssertions

  def setup
    User.delete_all
    CustomFieldStore.delete_all
  end

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
    user = nil

    assert_difference ->{ User.count }, 1 do
      assert_no_difference -> { CustomFieldStore.count } do
        user = User.new
        user.save
      end
    end


    user.created_at = time
    user.updated_at = time
    user.save

    assert_equal time, user.created_at
    assert_equal time, user.updated_at

    user.custom_field_store.write_custom_field :hometown, "Gotham"
    user.custom_field_store.save

    refute_equal time, user.updated_at
  end

  def test_updating_custom_field
    user = User.new
    user.hometown = "Gotham"
    store_id = nil

    assert_difference -> { CustomFieldStore.count }, 1 do
      assert user.custom_field_store.needs_saved?
      user.save
      refute user.custom_field_store.needs_saved?

      assert_equal "Gotham", user.hometown
      refute_nil user.custom_field_store.id
      store_id = user.custom_field_store.id
    end

    user = User.find(user.id)
    assert_equal store_id, user.custom_field_store.id
    assert_equal "Gotham", user.hometown
  end

  def test_fetching_custom_field_store_should_not_automatically_save
    assert_difference ->{ User.count }, 1 do
      assert_no_difference -> { CustomFieldStore.count } do
        User.connection.execute "INSERT INTO users (email) values ('test@example.com');"
      end
    end

    assert_no_difference -> { CustomFieldStore.count } do
      user = User.first
      user.hometown
    end
  end
end
