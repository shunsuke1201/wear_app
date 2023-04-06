require 'rails_helper'

RSpec.describe PostImage, type: :model do
  describe "画像アップロードのテスト" do
    let(:post) { create(:post) }
    let(:post_image) { create(:post_image, post: post) }

    it "画像ファイルをアップロードできること" do
      expect(post_image).to be_valid
      expect(post_image.image).to be_present
    end
  end
end