require "rails_helper"

RSpec.describe Expense, type: :model do
  describe 'expense#create' do
    context 'with valid params' do
      let(:expense) { create(:expense)}

      it 'Save with valid params' do
        #expect = ожидаем
        expect(expense).to be_valid
      end
    end
    
    context 'with invalid params' do
      let(:expense) { create(:expense, :without_title)}

      it 'Not saves without title' do
        expect{ expense }.to raise_error(ActiveRecord::RecordInvalid) # сама база данных вернет нам ошибку что без тайтла невозможно записать 
      end
    end

    context 'with invalid params' do
      let(:expense) { create(:expense, :without_value)}

      it 'Not saves without value' do
        expect{ expense }.to raise_error(Active::RecordInvalid)
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

    context 'spent_on_not_in_future' do
      let(:expense) { Expense.create(title: "House", value: 100000, spent_on: "17.05.2025", user: user)}
      let(:expense_in_future) { Expense.create(title: "House", value: 100000, spent_on: "25.05.2025", user: user)}

      it 'saves if not in the future' do
        expect(expense).to be_valid
      end

      it 'not saves if in the future' do
        expect(expense_in_future).to_not be_valid
        expect(expense_in_future.errors[:spent_on]).to include("can't be in the future") 
      end
    end
  end
end