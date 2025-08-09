class Client < ApplicationRecord
  belongs_to :user
  has_many :invoices, dependent: :destroy

  scope :for_user, ->(user) { where(user_id: user.id) }

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }
end
