require 'rails_helper'

RSpec.describe 'Expenses', type: :request do
  let(:user) { create(:user)}
  let(:expense) { create(:expense, user: user) }
  let(:valid_params) { attributes_for(:expense)} # артибутс фор смотрит  какой инишиалайз у экспэнса и передает это в  валид парамс!
  let(:invalid_params) {attributes_for(:expense, title: nil)}

  describe "GET /expenses" do
    context 'authenticated' do 
      include_context 'authenticated'
      let!(:expenses) { create_list(:expense, 3, user: user)} # cосздает массив в количесвте трёх созданий exmpens

      it 'returns 200 and list of expenses' do
        get expenses_path

        expect(response).to have_http_status(:ok) #когда мы зайдем на expenses_path то страница найдена и существует и всё окей
        expenses.each do |expense|
          expect(response.body).to include(expense.title) #когда мы зайдем на expenses_path то там будет 3 названия экспенсов
        end
      end
    end

    context 'not authenticated' do
      include_examples 'redirects to login', :get, proc { expenses_path } # это тоже самое что и 9 строка
    end
  end

  describe "GET /expenses/:id" do
    context 'authenticated' do
      include_context 'authenticated' 
      it 'returns show page with params' do
        get expense_path(expense)
        expect(response).to have_http_status(:ok)
        [
          "EXPENSE #{expense.id}",
          "#{expense.title}",
          "#{expense.value}",
          "#{expense.spent_on}"
        ].each do |expected_param|
          expect(response.body).to include(expected_param)
        end  
      end
    end

    context 'not authenticated' do
      include_examples 'redirects to login', :get, proc { expenses_path(expense) } # это тоже самое что и 9 строка
    end
  end
end