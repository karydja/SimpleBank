require 'rails_helper'

RSpec.describe 'money transfer', type: :request do
  let(:destination_account) { create(:account) }
  let(:source_account) { create(:account) }
  let(:transfer_params) do
    {
      amount: 100,
      destination_account_id: destination_account.id,
      source_account_id: source_account.id
    }
  end

  context 'with valid params' do
    it 'creates a Transfer' do
      expect { post '/v1/transfers', params: { transfer: transfer_params } }.to change{ Transfer.count }.by(1)
    end

    it 'returns a 201 status' do
      post '/v1/transfers', params: { transfer: transfer_params }

      expect(response).to have_http_status(:created)
    end

    it 'returns an application/json content-type' do
      post '/v1/transfers', params: { transfer: transfer_params }

      expect(response.content_type).to eq('application/json')
    end

    it 'returns a valid JSON' do
      post '/v1/transfers', params: { transfer: transfer_params }

      expect { (JSON.parse(response.body)) }.not_to raise_error
    end

    it 'returns a JSON in the expected format' do
      post '/v1/transfers', params: { transfer: transfer_params }

      transfer = Transfer.last
      transfer_destination_account = Account.find(destination_account.id)
      transfer_source_account = Account.find(source_account.id)
      expected_response = {
        data: {
          id: transfer.id,
          type: 'Transfer',
          attributes: {
            amount: BigDecimal.new(transfer_params[:amount]),
            sourceAccountId: transfer_source_account.id,
            destinationAccountId: transfer_destination_account.id,
            createdAt: transfer.created_at,
            updatedAt: transfer.updated_at
          },
          relationships: {
            sourceAccount: {
              data: {
                id: transfer_source_account.id,
                type: 'Account',
                attributes: {
                  name: transfer_source_account.name,
                  createdAt: transfer_source_account.created_at,
                  updatedAt: transfer_source_account.updated_at
                }
              }
            },
            destinationAccount: {
              data: {
                id: transfer_destination_account.id,
                type: 'Account',
                attributes: {
                  name: transfer_destination_account.name,
                  createdAt: transfer_destination_account.created_at,
                  updatedAt: transfer_destination_account.updated_at
                }
              }
            }
          }
        }
      }.to_json

      expect(response.body).to eq(expected_response)
    end
  end

  context 'with invalid params' do
    context 'source_account_id' do
      let(:params_with_invalid_source_acount_id) do
        transfer_params.merge({ source_account_id: 0 })
      end

      it 'raises an error' do
        expect do
          post '/v1/transfers', params: { transfer: params_with_invalid_source_acount_id }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'destination_account_id' do
      let(:params_with_invalid_destination_acount_id) do
        transfer_params.merge({ destination_account_id: 0 })
      end

      it 'raises an error' do
        expect do
          post '/v1/transfers', params: { transfer: params_with_invalid_destination_acount_id }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'amount format' do
      let(:params_with_invalid_amount_format) do
        transfer_params.merge({ amount: 10.123 })
      end

      it 'raises an error' do
        expect do
          post '/v1/transfers', params: { transfer: params_with_invalid_amount_format }
        end.to raise_error(ActiveRecord::RecordNotSaved)
      end
    end
  end

  context 'when the source account has insufficient funds' do
    let(:params_with_source_account_with_insufficient_funds) do
      transfer_params.merge({ amount: source_account.balance + 100.00 })
    end

    it 'raises an error' do
      expect do
        post '/v1/transfers', params: { transfer: params_with_source_account_with_insufficient_funds }
      end.to raise_error(ActiveRecord::RecordNotSaved)
    end
  end
end
