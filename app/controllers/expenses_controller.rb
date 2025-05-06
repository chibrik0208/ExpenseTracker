class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]

  def index
    @expenses = Expense.all
  end

  def show                                                                                            
  end
  
  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

 
  private

  def expense_params
    params.require(:expense).permit(:title, :value, :spent_on)
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end
end