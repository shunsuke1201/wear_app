class CreatePostImages < ActiveRecord::Migration[6.0]
  def change
    create_table :post_images do |t|
      t.integer :post_id
      t.string :image_id

      t.timestamps
    end
  end
end
