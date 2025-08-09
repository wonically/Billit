class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :description, :amount, :category, :expense_date, :created_at

  def expense_date
    object.expense_date.iso8601
  end
end
