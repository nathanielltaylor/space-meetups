class CreateUsermeetups < ActiveRecord::Migration
  def change
    create_table :usermeetups do |table|
      table.string :meetup_id, null: false
      table.string :user_id, null: false
    end
  end
end
