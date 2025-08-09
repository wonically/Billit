class LineItem < ApplicationRecord
  belongs_to :invoice

  scope :for_user, ->(user) { joins(:invoice).where(invoices: { user_id: user.id }) }
  
  validates :description, :quantity, :unit_price, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }

  def total
    quantity * unit_price
  end
end
