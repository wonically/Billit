require 'rails_helper'

RSpec.describe 'Clients API serialization', type: :request do
  let(:user) { create(:user) }
  let!(:clients) { create_list(:client, 2, user: user) }
  let(:client) { clients.first }

  before { sign_in user }

  describe 'GET /clients' do
    it 'returns serialized clients with required keys' do
      get '/clients'
      expect(response).to have_http_status(:ok)
      json.each do |obj|
        expect(obj.keys).to include('id', 'name', 'email', 'created_at', 'updated_at')
      end
    end
  end

  describe 'GET /clients/:id' do
    it 'returns serialized client with required keys' do
      get "/clients/#{client.id}"
      expect(response).to have_http_status(:ok)
      expect(json.keys).to include('id', 'name', 'email', 'created_at', 'updated_at')
    end

    it 'returns 404 for non-existent client' do
      get "/clients/0"
      expect(response).to have_http_status(:not_found)
    end
  end
end
