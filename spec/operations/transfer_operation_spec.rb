require 'rails_helper'

RSpec.describe TransferOperation do
  let(:source_account) { create(:account) }
  let(:destination_account) { create(:account) }
  let(:source_account_id) { source_account.id }
  let(:destination_account_id) { destination_account.id }
  let(:amount) { '2000.00' }
  subject { TransferOperation.new(source_account_id, destination_account_id, amount) }

  context '#operate' do
    context 'with valid arguments' do
      it 'debits money in source account' do
        original_source_account_balance = source_account.balance
        new_source_account_balance = original_source_account_balance - BigDecimal.new(amount)

        expect { subject.operate }
          .to change { Account.find(source_account.id).balance }
          .from(original_source_account_balance)
          .to(new_source_account_balance)
      end

      it 'credits money in destination account' do
        original_destination_account_balance = source_account.balance
        new_destination_account_balance = original_destination_account_balance + BigDecimal.new(amount)

        expect { subject.operate }
          .to change { Account.find(destination_account.id).balance }
          .from(original_destination_account_balance)
          .to(new_destination_account_balance)
      end

      it 'creates a Transfer' do
        expect { subject.operate }.to change { Transfer.count }.by(1)
      end

      it 'returns a Transfer' do
        expect(subject.operate).to be_a(Transfer)
      end
    end

    context 'with invalid arguments' do
      context 'source_account_id' do
        let(:source_account_id) { 0 }

        it 'raises an error' do
          expect { subject.operate }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'destination_account_id' do
        let(:destination_account_id) { 0 }

        it 'raises an error' do
          expect { subject.operate }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'amount format' do
        let(:amount) { '100.011' }

        it 'raises an error' do
          expect { subject.operate }.to raise_error(ActiveRecord::RecordNotSaved)
        end
      end
    end
  end

  context 'when the source account has insufficient funds' do
    let(:amount) { source_account.balance + 1 }

    it 'raises an error' do
      expect { subject.operate }.to raise_error(ActiveRecord::RecordNotSaved)
    end
  end

  context 'when source and destination accounts are the same' do
    let(:destination_account_id) { source_account.id }

    it 'raises an error' do
      expect { subject.operate }.to raise_error(ActiveRecord::RecordNotSaved)
    end
  end
end
