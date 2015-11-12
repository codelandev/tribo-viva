require 'rails_helper'

RSpec.describe OfferItem, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unit) }
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:unit_price) }
  end

  describe "relations" do
    it { is_expected.to belong_to(:offer) }
  end
end
