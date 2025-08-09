require 'rails_helper'

RSpec.describe 'Api::Expenses', type: :request do
  let(:user) { create(:user) }
  let!(:expenses) { create_list(:expense, 2, user: user) }
  let(:expense) { expenses.first }
  let!(:other_expense) { create(:expense) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:expense1) { create(:expense, user: user1) }
  let!(:expense2) { create(:expense, user: user2) }
  let(:headers) { user1.create_new_auth_token }

  before { sign_in user }

  describe 'GET /api/expenses' do
    it 'returns only current_user expenses' do
      get '/api/expenses'
      expect(response).to have_http_status(:ok)
      ids = json_body.map { |exp| exp['id'] }
      expect(ids).to match_array(expenses.map(&:id))
      expect(ids).not_to include(other_expense.id)
    end

    it "returns only expenses belonging to the authenticated user" do
      get "/api/expenses", headers: headers
      expect(json.size).to eq(1)
      expect(json.first["id"]).to eq(expense1.id)
    end
  end

  describe 'GET /api/expenses/:id' do
    it 'returns a single expense' do
      get "/api/expenses/#{expense.id}"
      expect(response).to have_http_status(:ok)
      expect(json_body['id']).to eq(expense.id)
    end

    it 'returns 404 for non-owned expense' do
      get "/api/expenses/#{other_expense.id}"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/expenses' do
    it 'creates a new expense' do
      expense_params = {
        description: 'Lunch',
        amount: 15.5,
        category: 'travel',
        expense_date: Date.today
      }
      expect {
        post '/api/expenses', params: { expense: expense_params }
      }.to change(user.expenses, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_body['description']).to eq('Lunch')
    end

    it "returns 403 Forbidden for non-admin users" do
      post "/api/expenses", params: { expense: { description: "Test", amount: 10, category: "Office", expense_date: Date.today } }, headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PATCH /api/expenses/:id' do
    it 'updates an expense' do
      patch "/api/expenses/#{expense.id}", params: { expense: { description: 'Updated' } }
      expect(response).to have_http_status(:ok)
      expect(expense.reload.description).to eq('Updated')
    end

    it 'returns 404 for non-owned expense' do
      patch "/api/expenses/#{other_expense.id}", params: { expense: { description: 'Updated' } }
      expect(response).to have_http_status(:not_found)
    end

    it "returns 403 Forbidden for non-admin users" do
      patch "/api/expenses/#{expense1.id}", params: { expense: { amount: 20 } }, headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /api/expenses/:id' do
    it 'deletes an expense' do
      expect {
        delete "/api/expenses/#{expense.id}"
      }.to change(user.expenses, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 for non-owned expense' do
      delete "/api/expenses/#{other_expense.id}"
      expect(response).to have_http_status(:not_found)
    end

    it "returns 403 Forbidden for non-admin users" do
      delete "/api/expenses/#{expense1.id}", headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end
end
