require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe 'associations' do
    it { should belong_to(:invoice) }
  end

  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
  end

  describe '#total' do
    it 'returns quantity * unit_price' do
      line_item = build(:line_item, quantity: 2, unit_price: 50)
      expect(line_item.total).to eq(100)
    end
  end
end
