class TransferOperation
  CURRENCY_FORMAT_REGEX = /\A\d{1,6}(\.\d{0,2})?\z/

  attr_reader :source_account, :destination_account, :amount_string, :amount

  def initialize(source_account_id, destination_account_id, amount)
    @source_account = Account.find(source_account_id)
    @destination_account = Account.find(destination_account_id)
    @amount_string = amount
    @amount = BigDecimal.new(amount)
  end

  def operate
    validate_enough_funds_in_source_account
    validate_amount_currency_format
    validate_different_accounts

    Transfer.transaction do
      debit_on_source_account
      credit_on_destination_account
      create_transfer
    end
  end

  private

  def create_transfer
    Transfer.create!(
      source_account: source_account,
      destination_account: destination_account,
      amount: amount
    )
  end

  def validate_enough_funds_in_source_account
    if source_account.balance < amount
      raise ActiveRecord::RecordNotSaved, 'Non-sufficient funds'
    end
  end

  def validate_amount_currency_format
    if CURRENCY_FORMAT_REGEX.match(amount_string).nil?
      raise ActiveRecord::RecordNotSaved, 'Invalid currency format'
    end
  end

  def validate_different_accounts
    if source_account.id == destination_account.id
      raise ActiveRecord::RecordNotSaved, 'Accounts must be different'
    end
  end

  def debit_on_source_account
    new_balance = source_account.balance - amount

    source_account.update!(balance: new_balance)
  end

  def credit_on_destination_account
    new_balance = destination_account.balance + amount

    destination_account.update!(balance: new_balance)
  end
end
