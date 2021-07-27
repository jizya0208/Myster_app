FactoryBot.define do
  factory :article do
    association :member # memberモデルアソシエーション
    association :category
    title { Faker::Lorem.characters(number: 20) }
    body { Faker::Lorem.characters(number: 80) }
  end
end