require 'rails_helper'

RSpec.describe 'Expenses API serialization', type: :request do
  let(:user) { create(:user) }
  let!(:expenses) { create_list(:expense, 2, user: user) }
  let(:expense) { expenses.first }

  before { sign_in user }

  describe 'GET /expenses' do
    it 'returns serialized expenses with required keys' do
      get '/expenses'
      expect(response).to have_http_status(:ok)
      json.each do |obj|
        expect(obj.keys).to include('id', 'description', 'amount', 'expense_date')
      end
    end
  end

  describe 'GET /expenses/:id' do
    it 'returns serialized expense with required keys' do
      get "/expenses/#{expense.id}"
      expect(response).to have_http_status(:ok)
      expect(json.keys).to include('id', 'description', 'amount', 'expense_date')
    end

    it 'returns 404 for non-existent expense' do
      get "/expenses/0"
      expect(response).to have_http_status(:not_found)
    end
  end
end
