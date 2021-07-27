FactoryBot.define do
  factory :member do
    name { Faker::Lorem.characters(number: 5) }
    email { Faker::Internet.email } # 実際のemailアドレスの形を指定
    password { Faker::Lorem.characters(number: 10) }
  end
end