require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションテスト' do
    let(:user) { create(:user) }
    let(:post) { build(:post, user: user) }

    it 'item, body, post_imagesがあれば有効な状態であること' do
      expect(post).to be_valid
    end

    it 'itemがなければ無効な状態であること' do
      post.item = nil
      expect(post).not_to be_valid
    end

    it 'bodyがなければ無効な状態であること' do
      post.body = nil
      expect(post).not_to be_valid
    end

    it 'post_imagesがなければ無効な状態であること' do
      post.post_images = []
      expect(post).not_to be_valid
    end
  end
  
  describe 'アソシエーションテスト' do
    it 'Userとの関連付けがされていること' do
      expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'Favoriteモデルとの関連付けがされていること' do
      expect(Post.reflect_on_association(:favorites).macro).to eq :has_many
    end

    it 'PostImageモデルとの関連付けがされていること' do
      expect(Post.reflect_on_association(:post_images).macro).to eq :has_many
    end
  end
  
  describe 'カスタムメソッドテスト' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
    let!(:favorite) { create(:favorite, user_id: user.id, post_id: post.id) }

    describe 'favorite_userメソッドのテスト' do
      context 'ユーザーがお気に入りをしている場合' do
        it 'favoriteレコードが返される' do
          expect(post.favorite_user(user.id)).to eq favorite
        end
      end
  
      context 'ユーザーがお気に入りをしていない場合' do
        it 'nilが返される' do
          expect(post.favorite_user(user.id + 1)).to be_nil
        end
      end
    end
  end
  
end