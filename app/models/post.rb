class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_images, dependent: :destroy
  accepts_attachments_for :post_images, attachment: :image, append: :true
  attachment :image
  
  with_options presence: true do
    validates :item
    validates :body
  end
  
  def favorite_user(user_id)
    favorites.find_by(user_id: user_id)
  end
end
