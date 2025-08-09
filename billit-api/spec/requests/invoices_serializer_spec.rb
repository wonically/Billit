require 'rails_helper'

RSpec.describe 'Invoices API serialization', type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client, user: user) }
  let!(:invoices) do
    Array.new(2) do
      invoice = create(:invoice, user: user, client: client)
      create(:line_item, invoice: invoice)
      invoice
    end
  end
  let(:invoice) { invoices.first }

  before { sign_in user }

  describe 'GET /invoices' do
    it 'returns serialized invoices with required keys and nested line_items' do
      get '/invoices'
      expect(response).to have_http_status(:ok)
      json.each do |inv|
        expect(inv.keys).to include('id', 'client_name', 'due_date', 'status', 'total', 'line_items')
        expect(inv['line_items']).to be_an(Array)
        inv['line_items'].each do |li|
          expect(li.keys).to include('id', 'description', 'quantity', 'unit_price', 'total')
        end
      end
    end
  end

  describe 'GET /invoices/:id' do
    it 'returns serialized invoice with required keys and nested line_items' do
      get "/invoices/#{invoice.id}"
      expect(response).to have_http_status(:ok)
      expect(json.keys).to include('id', 'client_name', 'due_date', 'status', 'total', 'line_items')
      expect(json['line_items']).to be_an(Array)
      json['line_items'].each do |li|
        expect(li.keys).to include('id', 'description', 'quantity', 'unit_price', 'total')
      end
    end

    it 'returns 404 for non-existent invoice' do
      get "/invoices/0"
      expect(response).to have_http_status(:not_found)
    end
  end
end
