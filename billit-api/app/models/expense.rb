class Expense < ApplicationRecord
  belongs_to :user

  scope :for_user, ->(user) { where(user_id: user.id) }
  
  validates :description, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: %w[travel software hardware office other] }
  validates :expense_date, presence: true

  scope :recent, -> { order(expense_date: :desc) }
end
