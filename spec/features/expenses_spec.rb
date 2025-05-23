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
      
      puts page.body
      expect(page).to have_content("coffee")
      expect(page).to have_content(555)
      expect(page).to have_content('2025-05-23')
    end
  end
end

