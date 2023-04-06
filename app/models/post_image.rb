class PostImage < ApplicationRecord
  belongs_to :post
  attachment :image
  validates :image, presence: true
end
