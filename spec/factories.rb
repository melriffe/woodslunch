FactoryGirl.define do

  factory :account do
    balance 0
  end

  factory :user do
    association :account
    sequence(:email) {|n|
      "#{Faker::Name.first_name}.#{Faker::Name.last_name}#{n}@example.com".
        downcase
    }
    password 'secret'
  end

  factory :admin, :parent => :user do
    roles { [:admin] }
  end

  factory :menu_item do
    sequence(:name) {|n| "Menu item #{n}"}
    price { MenuItem::DEFAULT_PRICE }
  end

  factory :daily_menu_item do
    association :menu_item
    day_of_week { DayOfWeek.first }
  end

  factory :student do
    association :user
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    grade Student::GRADES.sample
  end

  factory :order do
    association :student
    served_on { Date.civil(2011, 4, 1) }
    total 0
  end

    factory :ordered_menu_item do
    association :order
    association :menu_item
  end
end
