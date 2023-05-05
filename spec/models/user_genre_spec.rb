require 'rails_helper'

RSpec.describe UserGenre, type: :model do
  describe 'アソシエーションテスト' do
    it 'Userとの関連付けがされていること' do
      expect(UserGenre.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'UserGenreとの関連付けがされていること' do
      expect(UserGenre.reflect_on_association(:genre).macro).to eq :belongs_to
    end
  end
end
