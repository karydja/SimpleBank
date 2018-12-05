require 'rails_helper'

RSpec.describe Account, :type => :model do
  it { should validate_numericality_of(:balance).is_greater_than(0) }

  it { should validate_presence_of(:balance) }
  it { should validate_presence_of(:name) }
end
