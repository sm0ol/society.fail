class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
