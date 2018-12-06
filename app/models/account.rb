class Account < ApplicationRecord
  validates_numericality_of :balance, greater_than: 0

  validates_presence_of :balance
  validates_presence_of :name
end
