class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :line_items, allow_destroy: true

  enum status: { draft: 0, sent: 1, paid: 2, overdue: 3 }

  validates :client, :due_date, :issue_date, :status, presence: true
  validate :due_date_after_issue_date

  private

  def due_date_after_issue_date
    if due_date.present? && issue_date.present? && due_date < issue_date
      errors.add(:due_date, 'must be on or after issue date')
    end