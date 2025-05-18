FactoryBot.define do
  factory :expense do
    title { Faker::Name.name[1,16] } # придумай рандомное имя из своих библеоток длинной от 1 до 16
    value { Faker::Number.between(from: 1, to: 100000)} #придумай рандомное число  для value от от 1 до 100000
    spent_on { Faker::Date.backward(days: 30) } # придумай рандомную дату от сегодня до месяц назад и запиши в переменную spent_on

    association :user #expense будет создаваться с ассоциациями юзер но мы её пропишем в фактори user  

    trait :without_title do
      title { nil }
    end

    trait :without_value do
      value { nil }
    end

    trait :without_spent_on do
      spent_on { nil }
    end

    trait :without_user do
      user { nil }
    end
  end
end