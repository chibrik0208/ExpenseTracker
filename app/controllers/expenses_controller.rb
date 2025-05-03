class ExpensesController < ApplicationController
  def index
    @expenses = Expense.all
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

  private

  def expense_params
    params.require(:expense).permit(:title, :value, :spent_on)
  end
end