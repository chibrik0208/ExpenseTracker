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

  describe "POST /expenses" do
    context 'with valid params' do
       include_context 'authenticated'

       it 'creates expense and redirects' do
        expect { post expenses_path, params: {expense: valid_params} }.to change(user.expenses, :count).by(1) # когда отправляем пост запрос при созании экспенса ожидаем что кол-во экспенсов у юзера  изменится на 1.
        expect(response).to redirect_to(expense_path(Expense.last))
       end
    end

    context 'with invalid params' do
       include_context 'authenticated'

       it 'not saves and returns 422' do
        expect { post expenses_path, params: {expense: invalid_params} }.to_not change(Expense, :count) # когда отправляем пост запрос при созании экспенса ожидаем что кол-во экспенсов у юзера не изменится
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
        expect(response.body).to include('Create new expense')
       end
    end
  end

  describe "GET #new" do
    context 'authenticated' do
      include_context 'authenticated'

      it 'renders form' do
        get new_expense_path # вот эту штуку делает gem rails-controller-testing

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
        expect(response.body).to include('Create new expense')
      end
    end

    context 'not authenticated' do
      include_examples 'redirects to login', :get, proc { expenses_path } 
    end
  end

  describe "PATCH /expenses/:id" do
    let!(:old_expense) { create(:expense, user: user, title: 'old_title') }
    let(:updated_expense) {{ title: 'new_title', value: old_expense.value, spent_on: old_expense.spent_on }}

    context 'authenticated' do
      include_context 'authenticated'

      context 'with valid params' do
        it 'renders form' do
          get edit_expense_path(expense)

          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:edit)
          expect(response.body).to include('Edit your expense')
        end
        
        it 'updates expense' do
          expect {
            patch expense_path(old_expense), params: { expense: updated_expense }
            old_expense.reload
          }.to change{ old_expense.title }.from('old_title').to('new_title')

          expect(response).to redirect_to(expense_path(old_expense))
        end
      end
      
      context 'with invalid params' do
        let!(:expense) { create(:expense, user: user)}
        
        it 'returns 422 and renders edit' do
          expect { patch expense_path(expense), params: {expense: invalid_params} }.to_not change(Expense, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          expect(response.body).to include('Edit your expense') 
        end
      end
    end

    context 'not authenticated' do
      include_examples 'redirects to login', :patch, proc { expense_path(expense) }
    end
  end
end