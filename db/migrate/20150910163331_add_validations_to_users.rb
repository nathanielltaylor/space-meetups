class AddValidationsToUsers < ActiveRecord::Migration
  def up
    change_column :user_meetups, :meetup_id, :integer, numericality: true
    change_column :user_meetups, :user_id, :integer, numericality: true
    change_column :users, :username, :string, uniqueness: true
    change_column :users, :email, :string, uniqueness: true
  end

  def down
    change_column :user_meetups, :meetup_id, :integer
    change_column :user_meetups, :user_id, :integer
    change_column :users, :username, :string
    change_column :users, :email, :string
  end
end
