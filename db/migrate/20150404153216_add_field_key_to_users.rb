class AddFieldKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :field_key, :text
  end
end
