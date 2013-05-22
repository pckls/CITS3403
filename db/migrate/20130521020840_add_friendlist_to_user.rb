class AddFriendlistToUser < ActiveRecord::Migration
  def change
    add_column :users, :friendlist, :string
  end
end
