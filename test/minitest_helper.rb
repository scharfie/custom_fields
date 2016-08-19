$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'bundler/setup'
require 'custom_fields'

ActiveRecord::Base.establish_connection(
  "adapter" =>  'sqlite3',
  "database" =>  ':memory:'
)

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :email
    t.datetime :created_at
    t.datetime :updated_at
  end

  create_table :custom_field_store do |t|
    t.string :owner_type
    t.integer :owner_id
    t.text :custom_fields
  end
end
