FactoryBot.define do
  factory :user do
    email { Faker::Internet.email } # переменной email присвоить рандомный эмайл из библиотеки гема
    password { "secure123" } # пароль нет смысла проверять и нагружать систему
    password_confirmation { "secure123" } # тоже нет смысла нагружать
  end
end