class Expense < ApplicationRecord
  belongs_to :user
  has_one_attached :receipt

  scope :for_user, ->(user) { where(user_id: user.id) }
  
  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true, inclusion: { in: %w[travel software hardware office other] }
  validates :expense_date, presence: true

  enum category: {
    office: "office",
    travel: "travel",
    utilities: "utilities",
    other: "other"
  }

  scope :recent, -> { order(expense_date: :desc) }
end
