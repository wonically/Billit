class Api::ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :update, :destroy]
  before_action :require_admin, only: [:create, :update, :destroy]

  def index
    expenses = current_user.expenses
    if params[:start_date].present? && params[:end_date].present?
      expenses = expenses.where(expense_date: params[:start_date]..params[:end_date])
    end
    expenses = expenses.where(category: params[:category]) if params[:category].present?

    if params[:monthly_total] == 'true'
      monthly = expenses.group_by { |e| e.expense_date.strftime('%Y-%m') }
      totals = monthly.transform_values { |arr| arr.sum { |e| e.amount } }
      render json: totals
    else
      render json: expenses, each_serializer: ExpenseSerializer
    end
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
    params.require(:expense).permit(:description, :amount, :category, :expense_date, :receipt)
  end
end
