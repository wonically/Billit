require 'rails_helper'

RSpec.describe 'Api::Invoices', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end
  let!(:client) { create(:client, user: user) }
  let!(:invoices) { create_list(:invoice, 2, user: user, client: client) }
  let(:invoice) { invoices.first }

  describe 'GET /api/invoices' do
    it 'returns user invoices' do
      get '/api/invoices', headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'GET /api/invoices/:id' do
    it 'returns a single invoice' do
      get "/api/invoices/#{invoice.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(invoice.id)
    end
  end

  describe 'POST /api/invoices' do
    it 'creates an invoice with line items' do
      invoice_params = {
        client_id: client.id,
        issue_date: Date.today,
        due_date: Date.today + 7,
        status: 'draft',
        tax: 10.0,
        discount: 5.0,
        total: 100.0,
        note: 'Test invoice',
        line_items_attributes: [
          { description: 'Item 1', quantity: 2, unit_price: 50.0 }
        ]
      }
      expect {
        post '/api/invoices', params: { invoice: invoice_params }, headers: auth_headers
      }.to change(user.invoices, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['note']).to eq('Test invoice')
    end
  end

  describe 'PATCH /api/invoices/:id' do
    it 'updates an invoice' do
      patch "/api/invoices/#{invoice.id}", params: { invoice: { note: 'Updated note' } }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(invoice.reload.note).to eq('Updated note')
    end
  end

  describe 'DELETE /api/invoices/:id' do
    it 'deletes an invoice' do
      expect {
        delete "/api/invoices/#{invoice.id}", headers: auth_headers
      }.to change(user.invoices, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
