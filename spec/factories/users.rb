FactoryBot.define do
  factory :user do
    name { 'Mark' }
    email { 'mark.mondol@github.com' }

    trait :github do
      provider { 'github' }
      uid { SecureRandom.uuid }
      oauth_token { SecureRandom.uuid }
      github_username { 'mmo-wtag' }
    end

    trait :signed_up do
      password { 'abcd123' }
      email_confirmed_at { Time.zone.now }
    end
  end
end
