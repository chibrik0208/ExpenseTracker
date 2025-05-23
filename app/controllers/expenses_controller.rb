class ExpensesController < ApplicationController
  before_action :require_login #Перед каждым действием рильса проверяет вошел пользователь или нет и не пускает дальше если нет
  before_action :set_expense, only: %i[show edit update destroy]

  def index
    @expenses = current_user.expenses
  end

  def show                                                                                            
  end
  
  def new
    @expense = Expense.new
  end

  def create
    @expense = current_user.expenses.new(expense_params)

    if @expense.save
      redirect_to @expense
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to @expense
    else
      render :edit  
    end
  end

  def destroy
    @expense.destroy
    redirect_to root_path
  end

 
  private

  def expense_params
    params.require(:expense).permit(:title, :value, :spent_on)
  end

  def set_expense
    @expense = current_user.expenses.find(params[:id])
  end
end