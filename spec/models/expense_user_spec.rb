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
        expect{ expense }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid params' do
      let(:expense) { create(:expense, :without_spent_on)}

      it 'Not saves without spent_on' do
        expect{ expense }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'value' do
      let(:expense) { create(:expense)}
      let(:invalid_expense) { build(:expense, value: "not a num") }
      let(:expense_wrong_value) { build(:expense, value: 0) }

      it 'Is a number' do
        expect(expense.value).to be_a(Numeric)
      end

      it 'Is not saves if numer is invalid' do
        expect(invalid_expense).to_not be_valid
        expect(invalid_expense.errors[:value]).to include("is not a number")
      end

      it 'greatter than 0' do
        expect(expense.value).to be > 0
      end

      it 'less than 0' do
        expect(expense_wrong_value).to_not be_valid
        expect(expense_wrong_value.errors[:value]).to include("must be greater than 0") #говорим ему какую ошибку мы ожидаем дословно как в консоли
      end
    end

    context 'title' do
      let!(:expense) { create(:expense, title: "uniq title") }
      let(:expense_long_title) { build(:expense, title: "TESTTESTTESTTESTTESTETETSTTEST") }
      let(:duplicate_expense) { build(:expense, title: "uniq title") }

      it 'less or equal 16' do
        expect(expense.title.length).to be <= 16
      end

      it 'more than 16' do
        expect(expense_long_title).to_not be_valid
        expect(expense_long_title.errors[:title]).to include("is too long (maximum is 16 characters)")
      end

      it 'does not allows to duplicate title' do
        expect(duplicate_expense).to_not be_valid
        expect(duplicate_expense.errors[:title]).to include("has already been taken")
      end
    end

    context 'spent_on_not_in_future' do
      let(:expense) { create(:expense) }
      let(:expense_in_future) { build(:expense, spent_on: Date.today + 1) }
      let(:expense_wrong_format) { build(:expense, spent_on: "i'm a wrong date")}

      it 'saves if not in the future' do
        expect(expense).to be_valid
      end

      it 'not saves if in the future' do
        expect(expense_in_future).to_not be_valid
        expect(expense_in_future.errors[:spent_on]).to include("can't be in the future") 
      end

      # it 'saves wirh correct format' do
      #   expect(expense.spent_on.strftime('%Y%M%D')). 
      # end

      it 'not saves with incorrect format' do
        expect(expense_wrong_format).to_not be_valid
        expect(expense_wrong_format.errors[:spent_on]).to include("can't be blank") 
      end
    end
  end
  
  describe 'associations' do
    context 'with invalid params' do
      let(:expense) { create(:expense) }
      let(:expense_no_user) { build(:expense, :without_user) } # build это просьба тесту попытаться сделать запрос в БД

      it 'creates with exist user' do
        expect(expense).to be_valid
      end

      it 'fails if user not exist' do
        expect(expense_no_user).to_not be_valid
      end
    end
  end
end