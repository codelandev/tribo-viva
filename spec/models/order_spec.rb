require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of :offer_id }
    it { is_expected.to validate_presence_of :quantity }
    it { is_expected.to validate_presence_of :purchase_id }
    it { is_expected.to validate_presence_of :offer_value }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0).is_less_than(4).only_integer }
  end

  describe 'Relations' do
    it { is_expected.to belong_to :offer }
    it { is_expected.to belong_to :purchase }
  end
end
