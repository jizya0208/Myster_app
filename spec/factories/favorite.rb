FactoryBot.define do
  factory :favorite do
    association :member
    association :article
  end
end