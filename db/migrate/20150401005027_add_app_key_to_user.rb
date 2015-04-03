class AddAppKeyToUser < ActiveRecord::Migration
  def change
    add_column :users, :app_key, :string
  end
end
