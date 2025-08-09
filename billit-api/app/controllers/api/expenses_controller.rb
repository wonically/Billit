class Api::ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :update, :destroy]
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    expenses = current_user.expenses.recent
    render json: expenses, each_serializer: ExpenseSerializer
  end

  def show
    render json: @expense, serializer: ExpenseSerializer
  end

  def create
    expense = current_user.expenses.build(expense_params)
    if expense.save
      render json: expense, serializer: ExpenseSerializer, status: 201
    else
      render json: { error: expense.errors.full_messages.join(', ') }, status: 422
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense, serializer: ExpenseSerializer, status: 200
    else
      render json: { error: @expense.errors.full_messages.join(', ') }, status: 422
    end
  end

  def destroy
    @expense.destroy
    head 204
  end

  private

  def require_admin
    unless current_user.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  def set_expense
    @expense = current_user.expenses.find_by(id: params[:id])
    render json: { error: 'Not found' }, status: :not_found unless @expense
  end

  def expense_params
    params.require(:expense).permit(:description, :amount, :category, :expense_date)
  end
end
