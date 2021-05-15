
FactoryBot.define do
  # sequence :username do |n|
  #   "user-#{n}"
  # end
  #
  # sequence :auth_id do |n|
  #   "passcode-#{n}"
  # end
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    user_type { 'user' }
    password { SecureRandom.alphanumeric }
  end

  factory :movie do
    title { Faker::Music.album }
  end
end