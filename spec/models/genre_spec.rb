require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe 'アソシエーションテスト' do
    it 'Userとの関連付けがされていること' do
      expect(Genre.reflect_on_association(:users).macro).to eq :has_many
    end

    it 'UserGenreとの関連付けがされていること' do
      expect(Genre.reflect_on_association(:user_genres).macro).to eq :has_many
    end
  end
end
