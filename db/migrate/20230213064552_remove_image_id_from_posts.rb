class RemoveImageIdFromPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :image_id, :string
  end
end
