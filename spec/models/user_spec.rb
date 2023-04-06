require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションテスト" do
    let(:user) { build(:user) }

    it "正しい属性を持っている場合は有効である" do
      expect(user).to be_valid
    end

    it "username, email, password, height, weightがなければ無効であること" do
      user = build(:user, username: nil, email: nil, password: nil, height: nil, weight: nil)
      user.valid?
      expect(user.errors[:username]).to include("を入力してください")
      expect(user.errors[:email]).to include("を入力してください")
      expect(user.errors[:password]).to include("を入力してください")
      expect(user.errors[:height]).to include("を入力してください")
      expect(user.errors[:weight]).to include("を入力してください")
    end
    
    it "usernameがなければ無効であること" do
      user.username = nil
      expect(user).to_not be_valid
    end
    
    it "emailがなければ無効であること" do
      user.email = nil
      expect(user).to_not be_valid
    end
    
    it "passwordがなければ無効であること" do
      user.password = nil
      expect(user).to_not be_valid
    end
    
    it "usernameが10文字より長ければ無効であること" do
      user.username = "a" * 11
      expect(user).to_not be_valid
    end
    
    it "heightがなければ無効であること" do
      user.height = nil
      expect(user).to_not be_valid
    end
    
    it "weightがなければ無効であること" do
      user.weight = nil
      expect(user).to_not be_valid
    end
    
    it "heightが0より小さければ無効であること" do
      user.height = -1
      expect(user).to_not be_valid
    end
    
    it "weightが0より小さければ無効であること" do
      user.weight = -1
      expect(user).to_not be_valid
    end
  end
  
  describe 'アソシエーションテスト' do
    it 'Postモデルとの関連付けがされていること'do
      expect(User.reflect_on_association(:posts).macro).to eq :has_many
    end
    
    it 'Favoriteモデルとの関連付けがされていること'do
      expect(User.reflect_on_association(:favorites).macro).to eq :has_many
    end
    
    it 'Relationshipモデルとの関連付けがされていること'do
      expect(User.reflect_on_association(:relationships).macro).to eq :has_many
    end
  end
end
