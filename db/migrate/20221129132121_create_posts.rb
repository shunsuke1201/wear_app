class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :item
      t.text :body
      t.string :image_id

      t.timestamps
    end
  end
end
