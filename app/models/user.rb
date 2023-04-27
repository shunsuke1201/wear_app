class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :profile_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  with_options presence: true do
    validates :username, length: { maximum: 10 }
    validates :email
    validates :password, on: :create
    validates :height, numericality: { greater_than_or_equal_to: 0, less_than: 300 }
    validates :weight, numericality: { greater_than_or_equal_to: 0, less_than: 300 }
  end
  
  def already_favorited?(post)
    self.favorites.exists?(post_id: post.id)
  end
  
  has_many :relationships, foreign_key: :following_id
  has_many :followings, through: :relationships, source: :follower
  
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :reverse_of_relationships, source: :following
  
  has_many :user_genres, dependent: :destroy
  has_many :genres, through: :user_genres
  
  def is_followed_by?(user)
    reverse_of_relationships.find_by(following_id: user.id).present?
  end
  
  def genre_match_percentage(user)
    common_genres = self.genres & user.genres
    total_genres = self.genres | user.genres
    (common_genres.count.to_f / total_genres.count.to_f * 100).round
  end
end
