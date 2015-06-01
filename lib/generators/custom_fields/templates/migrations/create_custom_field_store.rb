class CreateCustomFieldStore < ActiveRecord::Migration
  def change
    create_table(:custom_field_store) do |t|
      t.string :owner_type
      t.integer :owner_id
      t.text :custom_fields
      t.timestamps null: false
    end

    add_index :custom_field_store, [:owner_type, :owner_id], :name => :idx_on_owner
  end
end
