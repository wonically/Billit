require 'rails_helper'

RSpec.describe 'Api::Invoices', type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client, user: user) }
  let!(:invoices) { create_list(:invoice, 2, user: user, client: client) }
  let(:invoice) { invoices.first }
  let!(:other_invoice) { create(:invoice) }

  before { sign_in user }

  describe 'GET /api/invoices' do
    it 'returns only current_user invoices' do
      get '/api/invoices'
      expect(response).to have_http_status(:ok)
      ids = json_body.map { |inv| inv['id'] }
      expect(ids).to match_array(invoices.map(&:id))
      expect(ids).not_to include(other_invoice.id)
    end
  end

  describe 'GET /api/invoices/:id' do
    let!(:line_items) { create_list(:line_item, 2, invoice: invoice) }

    it 'returns invoice with client and line_items' do
      get "/api/invoices/#{invoice.id}"
      expect(response).to have_http_status(:ok)
      expect(json_body['id']).to eq(invoice.id)
      expect(json_body['client']).to eq(client.name)
      expect(json_body['line_items'].size).to eq(2)
    end
  end

  describe 'POST /api/invoices' do
    it 'creates invoice with nested line_items' do
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
        post '/api/invoices', params: { invoice: invoice_params }
      }.to change(user.invoices, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_body['note']).to eq('Test invoice')
      expect(json_body['line_items'].size).to eq(1)
      expect(json_body['line_items'][0]['description']).to eq('Item 1')
    end
  end

  describe 'PATCH /api/invoices/:id' do
    let!(:line_item) { create(:line_item, invoice: invoice, description: 'Old') }

    it 'updates invoice and its line_items' do
      patch "/api/invoices/#{invoice.id}", params: {
        invoice: {
          note: 'Updated note',
          line_items_attributes: [
            { id: line_item.id, description: 'Updated', quantity: 3, unit_price: 30.0 }
          ]
        }
      }
      expect(response).to have_http_status(:ok)
      expect(invoice.reload.note).to eq('Updated note')
      expect(invoice.line_items.first.description).to eq('Updated')
      expect(invoice.line_items.first.quantity).to eq(3)
    end
  end

  describe 'DELETE /api/invoices/:id' do
    it 'deletes invoice' do
      expect {
        delete "/api/invoices/#{invoice.id}"
      }.to change(user.invoices, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'user scoping and admin-only restrictions' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:invoice1) { create(:invoice, user: user1) }
    let!(:invoice2) { create(:invoice, user: user2) }
    let(:headers) { user1.create_new_auth_token }

    describe 'GET /api/invoices' do
      it 'returns only invoices belonging to the authenticated user' do
        get '/api/invoices', headers: headers
        expect(json.size).to eq(1)
        expect(json.first['id']).to eq(invoice1.id)
      end
    end

    describe 'POST /api/invoices' do
      it 'returns 403 Forbidden for non-admin users' do
        post '/api/invoices', params: { invoice: { client_id: invoice1.client_id, issue_date: Date.today, due_date: Date.today + 7, status: 'draft', total: 100 } }, headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'PATCH /api/invoices/:id' do
      it 'returns 403 Forbidden for non-admin users' do
        patch "/api/invoices/#{invoice1.id}", params: { invoice: { status: 'paid' } }, headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'DELETE /api/invoices/:id' do
      it 'returns 403 Forbidden for non-admin users' do
        delete "/api/invoices/#{invoice1.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
