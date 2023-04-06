require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "#new" do
    before do
      visit new_user_registration_path
    end

    it "新規登録ページが表示されていること" do
      expect(page).to have_content("新規登録")
    end

    it "新規登録に成功すること" do
      fill_in "user_username", with: "user"
      fill_in "user_email", with: "user@example.com"
      fill_in "user_height", with: "170"
      fill_in "user_weight", with: "60"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "登録"
      expect(page).to have_content("アカウント登録が完了しました。")
    end
    
    it "新規登録に失敗すること" do
      fill_in "user_username", with: "user"
      fill_in "user_email", with: ""
      fill_in "user_height", with: "170"
      fill_in "user_weight", with: "60"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "登録"
      expect(page).to have_content("エラーが発生したため ユーザー は保存されませんでした。")
    end
  end
  
  describe "index" do
    let!(:user1) { create(:user, username: "User1", email: "user1@example.com") }
    let!(:user2) { create(:user, username: "User2", email: "user2@example.com") }
    let!(:post1) { create(:post, user: user1) }
    let!(:post2) { create(:post, user: user1) }
    let!(:post3) { create(:post, user: user2) }
  
    before do
      visit users_path
    end

    it "ユーザー一覧ページが表示されること" do
      expect(page).to have_content("ユーザー一覧")
    end

    it "ユーザー名が表示されること" do
      expect(page).to have_content(user1.username)
      expect(page).to have_content(user2.username)
    end

    it "投稿数が表示されること" do
      within(find('div.title', text: user1.username).ancestor('div.column')) do
        expect(page).to have_content("投稿数：2")
      end

      within(find('div.title', text: user2.username).ancestor('div.column')) do
        expect(page).to have_content("投稿数：1")
      end
    end
  end
  
  describe "show" do
    let(:user) { create(:user) }
    let!(:post1) { create(:post, user: user, updated_at: Time.zone.parse('2023-04-05 16:09:00')) }
    let!(:post2) { create(:post, user: user, updated_at: Time.zone.parse('2023-04-05 16:10:00')) }
  
    before do
      sign_in user
      visit user_path(user)
    end
  
    it "ユーザー情報が表示されていること" do
      expect(page).to have_content(user.username)
      expect(page).to have_content("#{user.height}cm")
      expect(page).to have_content("#{user.weight}kg")
    end
  
    it "ユーザーの投稿が表示されていること" do
      expect(page).to have_selector('div.card', count: 2)
      within find("div.card", match: :first) do
        expect(page).to have_content(post1.item)
        expect(page).to have_content('2023年-04月-05日 16:09')
      end
      within all("div.card")[1] do
        expect(page).to have_content(post2.item)
        expect(page).to have_content('2023年-04月-05日 16:10')
      end
    end
  end
  
  describe "edit" do
  let(:user) { create(:user) }
  before do
    sign_in user
    # ユーザー編集ページにアクセス
    visit edit_user_path(user)
  end

  it "編集ページが表示されていること" do
    expect(page).to have_content("ユーザー編集")
  end

  it "ユーザー情報を編集できること" do
  fill_in "名前", with: "Update"
  fill_in "メールアドレス", with: "updated@example.com"
  fill_in "身長", with: 170
  fill_in "体重", with: 60

  # 画像のアップロードは、ローカル環境で実行する場合のみ有効です。
  # 以下のコメントアウトを解除して、実行してください。
  # attach_file "プロフィール画像", Rails.root.join("spec/fixtures/images/example.jpg")

  click_on "更新"

  expect(page).to have_content("Update") # 修正: "Update" の表示を確認する
  expect(page).to have_content("170cm")
  expect(page).to have_content("60kg")
  # 以下のコメントアウトを解除して、画像のアップロードのテストを実行してください。
  # expect(page).to have_selector("img[src$='example.jpg']")
end

  end
end
