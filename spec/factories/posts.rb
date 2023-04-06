FactoryBot.define do
  factory :post do
    item { "Example item" }
    body { "Example body" }
    user
    post_images { [FactoryBot.build(:post_image)] }
  end
end