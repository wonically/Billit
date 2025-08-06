require 'rails_helper'

RSpec.describe 'Api::Clients', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end
  let!(:clients) { create_list(:client, 3, user: user) }
  let(:client) { clients.first }

  describe 'GET /api/clients' do
    it 'returns user clients' do
      get '/api/clients', headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/clients/:id' do
    it 'returns a single client' do
      get "/api/clients/#{client.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(client.id)
    end
  end

  describe 'POST /api/clients' do
    it 'creates a client' do
      client_params = { name: 'New Client', company: 'NewCo', email: 'new@co.com', address: '123 Main St' }
      expect {
        post '/api/clients', params: { client: client_params }, headers: auth_headers
      }.to change(user.clients, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['name']).to eq('New Client')
    end
  end

  describe 'PATCH /api/clients/:id' do
    it 'updates a client' do
      patch "/api/clients/#{client.id}", params: { client: { name: 'Updated' } }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(client.reload.name).to eq('Updated')
    end
  end

  describe 'DELETE /api/clients/:id' do
    it 'deletes a client' do
      expect {
        delete "/api/clients/#{client.id}", headers: auth_headers
      }.to change(user.clients, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
