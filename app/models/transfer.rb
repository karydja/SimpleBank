class Transfer < ApplicationRecord
  belongs_to :destination_account, class_name: 'Account'
  belongs_to :source_account, class_name: 'Account'

  validates_numericality_of :amount, greater_than: 0

  validates_presence_of :amount
  validates_presence_of :destination_account
  validates_presence_of :source_account
end
