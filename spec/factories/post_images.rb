FactoryBot.define do
  factory :post_image do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_image.jpg'), 'image/jpeg') }
  end
end