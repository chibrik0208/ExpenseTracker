require 'rails_helper'

RSpec.describe 'Expenses', type: :system do
  let!(:user) { create(:user) }
  let!(:expense) { create(:expense, user: user) }

  def sign_in_as(user) 
    visit login_path
    fill_in "Enter your Email", with: user.email
    fill_in "Enter your password", with: user.password
    click_button "LOG IN"
  end

  before do # capybare нужен свой тестер и перед каждым It в тестах будет вставляться то что мы напишем
    driven_by(:rack_test)
  end

  context "not logged user" do
    it 'index redirect to login' do
      visit expenses_path
      expect(page).to have_content("Join us!")
    end

    it 'create redirect to login' do
      visit new_expense_path
      expect(page).to have_content("Join us!")
    end

    it 'update redirect to login' do
      visit edit_expense_path(expense)
      expect(page).to have_content("Join us!")
    end

    it 'show redirect to login' do
      visit expense_path(expense)
      expect(page).to have_content("Join us!")
    end
  end

  context "CRUD operations" do
    before do
      sign_in_as(user)
    end

    it 'create new expense' do
      visit new_expense_path
      fill_in "Enter Title", with: 'coffee'
      fill_in "Enter value", with: 555
      fill_in "Enter date", with: '23.05.2025'
      click_button "SAVE"
      
      expect(page).to have_content("coffee")
      expect(page).to have_content(555)
      expect(page).to have_content('2025-05-23')
    end

    it 'has updated content' do
      visit edit_expense_path(expense)
      fill_in "Enter Title", with: 'test_edit'
      fill_in "Enter value", with: 123
      fill_in "Enter date", with: '26.05.2025'
      click_button "SAVE"

      expect(page).to have_content('test_edit')
      expect(page).to have_content(123)
      expect(page).to have_content('2025-05-26')
    end

    it 'deletes content' do
      visit expense_path(expense)
      expect(page).to have_button('delete')
      click_button "delete"

      expect(page).to have_content("Your monthly expenses")
      expect(page).to_not have_content(expense.title)
    end
  end

  context 'validations' do
    before do
      sign_in_as(user)
      visit new_expense_path

      fill_in "Enter Title", with: filled_title
      fill_in "Enter value", with: filled_value
      fill_in "Enter date", with: filled_date

      click_button "SAVE"
    end

    context 'when title is missing' do
      let(:filled_title) { "" }
      let(:filled_value) { "100" }
      let(:filled_date) { "25.05.2025" }

      let(:expected_title) { "" }
      let(:expected_value) { "100" }
      let(:expected_date) { "2025-05-25" }

      include_examples 'form with preserved fields'
    end

    context 'when value is missing' do
      let(:filled_title) { "sisi" }
      let(:filled_value) { "" }
      let(:filled_date) { "25.05.2025" }

      let(:expected_title) { "sisi" }
      let(:expected_value) { "" }
      let(:expected_date) { "2025-05-25" }

      include_examples 'form with preserved fields'
    end

    context 'when data missing' do
      let(:filled_title) { "sisi" }
      let(:filled_value) { "250" }
      let(:filled_date) { "" }

      let(:expected_title) { "sisi" }
      let(:expected_value) { "250" }
      let(:expected_date) { nil }

      include_examples 'form with preserved fields'
    end

    context 'when title is longer than 16' do
      let(:filled_title) { "sisi1231231233124" }
      let(:filled_value) { "250" }
      let(:filled_date) { "25.05.2025" }

      let(:expected_title) { "sisi1231231233124" }
      let(:expected_value) { "250" }
      let(:expected_date) { "2025-05-25" }

      include_examples 'form with preserved fields'
    end

    context 'when title is longer than 16' do
      let(:filled_title) { "sisi12312312331" }
      let(:filled_value) { "-250" }
      let(:filled_date) { "25.05.2025" }

      let(:expected_title) { "sisi12312312331" }
      let(:expected_value) { "-250" }
      let(:expected_date) { "2025-05-25" }

      include_examples 'form with preserved fields'
    end

    context 'when value < 0' do
      let(:filled_title) { "sisi12312312331" }
      let(:filled_value) { "-250" }
      let(:filled_date) { "25.05.2025" }

      let(:expected_title) { "sisi12312312331" }
      let(:expected_value) { "-250" }
      let(:expected_date) { "2025-05-25" }

      include_examples 'form with preserved fields'
    end

    context 'when date is in the future' do
      let(:filled_title) { "sisi12312312331" }
      let(:filled_value) { "250" }
      let(:filled_date) { Date.today + 1 }

      let(:expected_title) { "sisi12312312331" }
      let(:expected_value) { "250" }
      let(:expected_date) { Date.today + 1 }

      include_examples 'form with preserved fields'
    end

    context 'when title is unique' do
      let!(:existing_expense) { create(:expense, user:user, title: "sisi") }
      let(:filled_title) { existing_expense.title }
      let(:filled_value) { "250" }
      let(:filled_date) { "25.05.2025" }

      let(:expected_title) { existing_expense.title }
      let(:expected_value) { "250" }
      let(:expected_date) { "2025-05-25" }

      include_examples 'form with preserved fields'
    end
  end
end

