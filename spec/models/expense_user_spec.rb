require "rails_helper"

RSpec.describe Expense, type: :model do
    #let = Пусть
  let(:user) { User.create(email:"hello@mal.ru", password:"123456") }

  describe 'expense#create' do
    context 'with valid params' do
      it 'Save with valid params' do
        expense = Expense.new(title:"Borispal", value: 800, spent_on: Date.today, user: user)
        #expect = ожидаем
        expect(expense).to be_valid
      end
    end
    
    context 'with invalid params' do
      it 'Not saves without title' do
        expense = Expense.new(value: 800, spent_on: Date.today, user: user)
        expect(expense).to_not be_valid
        expect(expense.errors[:title]).to include("can't be blank") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end
    end

    context 'with invalid params' do
      it 'Not saves without value' do
        expense = Expense.new(title:"Barispal", spent_on: Date.today, user: user)
        expect(expense).to_not be_valid
        expect(expense.errors[:value]).to include("can't be blank") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end
    end

    context 'with invalid params' do
      it 'Not saves without spent_on' do
        expense = Expense.new(title:"Barispal",value: 800, user: user)
        expect(expense).to_not be_valid
        expect(expense.errors[:spent_on]).to include("can't be blank") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end
    end

    context 'with invalid params' do
      it 'Not saves without user' do
        expense = Expense.new(title:"Barispal",value: 800, spent_on: Date.today)
        expect(expense).to_not be_valid
        expect(expense.errors[:user]).to include("must exist") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end
    end

    context 'value' do
      it 'Is a number' do
        expense = Expense.new(title:"Boria",value: 5.7, spent_on: Date.today, user: user)
        expect(expense).to be_valid
      end

      it 'Is not saves if numer is invalid' do
        expense = Expense.new(title:"Boria",value: 'hey', spent_on: Date.today, user: user)
        expect(expense).to_not be_valid
        expect(expense.errors[:value]).to include("is not a number") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end

      it 'greatter than 0' do
        expense = Expense.new(title:"Boria",value: 555, spent_on: Date.today, user: user)
        expect(expense).to be_valid
      end

      it 'less than 0' do
        expense = Expense.new(title:"Boria",value: -18, spent_on: Date.today, user: user)
        expect(expense).to_not be_valid
        expect(expense.errors[:value]).to include("must be greater than 0") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end
    end

    context 'title' do
      it 'less or equal 16' do
      expense = Expense.new(title:"Boriadddds",value: 20, spent_on: Date.today, user: user)
      expect(expense.title.length).to be <= 16
      end

      it 'more than 16' do
        expense = Expense.new(title:"Boriaddddsfdssfdsdfsfdsdffdsfdsdsfdfssdffsdsdfsdf",value: 20, spent_on: Date.today, user: user)
        expect(expense.title.length).to_not be <= 16
        expect(expense).to_not be_valid
        expect(expense.errors[:title]).to include("is too long (maximum is 16 characters)")
      end

      it 'does not allows to duplicate title' do
        Expense.create!(title:"Boriadddds",value: 20, spent_on: Date.today, user: user)
        expense = Expense.new(title:"Boriadddds",value: 20, spent_on: Date.today, user: user)
        expect(expense).to_not be_valid
        expect(expense.errors[:title]).to include("has already been taken")
      end
    end
  end
end