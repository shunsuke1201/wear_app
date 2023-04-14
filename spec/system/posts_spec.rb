require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe "#index" do
    let!(:post1) { FactoryBot.create(:post, item: 'hoge') }
    let!(:post2) { FactoryBot.create(:post, item: 'fuga') }

    before do
      visit posts_path
    end
    
    it "タイトルが投稿一覧" do
      expect(page).to have_content '投稿一覧'
    end

    context "検索フォームに値を入力したとき" do
      it "検索ワードに一致する投稿のみ表示されること" do
        within('.search-form') do
          fill_in 'q_item_cont', with: 'hoge'
          click_button '検索'
        end
        expect(page).to have_content 'hoge'
        expect(page).to_not have_content 'fuga'
      end
    end

    context "検索フォームに値を入力せずに検索したとき" do
      it "すべての投稿が表示されること" do
        click_button '検索'
        expect(page).to have_content 'hoge'
        expect(page).to have_content 'fuga'
      end
    end
  end
  
  describe "#new" do
    let(:user) { FactoryBot.create(:user) }
    before do
      sign_in user
      visit new_post_path
    end
    
    it "新規投稿" do
      expect(page).to have_content '新規投稿'
    end
    
    it "アイテム名、アイテム詳細、画像のフォームがあること" do
      expect(page).to have_field 'post[item]'
      expect(page).to have_field 'post[body]'
      expect(page).to have_field 'post[post_images_images][]'
    end
    
    it "入力が不十分な場合、投稿が作成されずエラーメッセージが表示されること" do
      fill_in "post[item]", with: ""
      fill_in "post[body]", with: ""
      expect { click_on "投稿" }.not_to change(Post, :count)
      expect(page).to have_content "アイテムを入力してください"
      expect(page).to have_content "アイテム詳細を入力してください"
    end
  end
  
  describe "#edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post, user: user, item: "Test Item", body: "Test Body") }
  
    before do
      sign_in user
      visit edit_post_path(post)
    end
  
    it "アイテム名、アイテム詳細、画像のフォームがあること" do
      expect(page).to have_field "post[item]", with: post.item
      expect(page).to have_field "post[body]", with: post.body
      expect(page).to have_field "post[post_images_images][]"
    end
  
    it "投稿の編集が成功すること" do
      fill_in "post[item]", with: "Updated Item"
      fill_in "post[body]", with: "Updated Body"
      click_on "投稿"
      expect(page).to have_content "更新しました"
      expect(post.reload.item).to eq "Updated Item"
      expect(post.reload.body).to eq "Updated Body"
    end
  
    it "入力が不十分な場合、投稿が更新されずエラーメッセージが表示されること" do
      fill_in "post[item]", with: ""
      fill_in "post[body]", with: ""
      click_on "投稿"
      expect(page).to have_content "アイテムを入力してください"
      expect(page).to have_content "アイテム詳細を入力してください"
    end
  end
  
  describe "#show" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post, user: user, item: "Test Item", body: "Test Body") }
    
    before do
      sign_in user
      visit post_path(post)
    end
  
    it "投稿のアイテム名が表示されていること" do
      expect(page).to have_content(post.item)
    end
  
    it "投稿のアイテム詳細が表示されていること" do
      expect(page).to have_content(post.body)
    end
  
    context "投稿者本人がログインしている場合" do
      it "編集ボタンが表示されること" do
        expect(page).to have_link "編集", href: edit_post_path(post)
      end
  
      it "削除ボタンが表示されること" do
        expect(page).to have_link "削除", href: post_path(post)
      end
    end
  
    context "投稿者本人ではないユーザーがログインしている場合" do
      let(:other_user) { create(:user) }
  
      before do
        sign_out user
        sign_in other_user
        visit post_path(post)
      end
  
      it "編集ボタンが表示されないこと" do
        expect(page).not_to have_link "編集", href: edit_post_path(post)
      end
  
      it "削除ボタンが表示されないこと" do
        expect(page).not_to have_link "削除", href: post_path(post)
      end
    end
  end
end