# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :retwet do
    twet { FactoryGirl.create(:twet) }
    user { FactoryGirl.create(:user) }
  end
end