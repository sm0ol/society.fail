class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username
      t.string :name
      t.text :bio
      t.string :location
      t.datetime :joined_at
      t.string :creator_ip

      t.timestamps
    end
  end
end
