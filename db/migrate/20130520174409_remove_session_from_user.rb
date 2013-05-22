class RemoveSessionFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :session
  end

  def down
    add_column :users, :session, :datatype
  end
end
