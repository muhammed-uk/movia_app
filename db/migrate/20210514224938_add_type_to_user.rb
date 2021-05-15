class AddTypeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_type, :string, default: 'user'
  end
end
