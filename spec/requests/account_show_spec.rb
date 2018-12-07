require 'rails_helper'

RSpec.describe 'account show', type: :request do
  before do
    get "/v1/accounts/#{account_id}",
      headers: { 'Content-Type' => 'application/vnd.api+json' }
  end

  context 'with valid headers and params' do
    let(:account) { create(:account) }
    let(:account_id) { account.id }

    it 'returns a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns an application/vnd.api+json content-type' do
      expect(response.content_type).to eq('application/vnd.api+json')
    end

    it 'returns a valid JSON' do
      expect { (JSON.parse(response.body)) }.not_to raise_error
    end

    it 'returns a JSON in the expected format' do
      expected_response = {
        data: {
          id: account.id,
          type: 'Account',
          attributes: {
            name: account.name,
            balance: account.balance
          }
        }
      }.to_json

      expect(response.body).to eq(expected_response)
    end
  end

  context 'with invalid params' do
    let(:account_id) { 0 }

    context 'account id' do
      it 'returns a 404 status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an application/vnd.api+json content-type' do
        expect(response.content_type).to eq('application/vnd.api+json')
      end

      it 'returns a valid JSON' do
        expect { (JSON.parse(response.body)) }.not_to raise_error
      end

      it 'returns a JSON error in the expected format' do
        expected_response = {
          errors: [
            {
              status: '404',
              title: 'RecordNotFound',
              detail: "Couldn't find Account with 'id'=#{account_id}"
            }
          ]
        }.to_json

        expect(response.body).to eq(expected_response)
      end
    end
  end
end
