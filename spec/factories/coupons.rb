# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    coupon_code "MyString"
    used false
    subscriber_email "MyString"
  end
end
