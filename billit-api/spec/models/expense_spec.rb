require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:expense_date) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_inclusion_of(:category).in_array(%w[travel software hardware office other]) }
  end

  describe '.recent' do
    it 'orders by expense_date desc' do
      older = create(:expense, expense_date: Date.yesterday)
      newer = create(:expense, expense_date: Date.today)
      expect(Expense.recent.first).to eq(newer)
      expect(Expense.recent.second).to eq(older)
    end
  end
end
