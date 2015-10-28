require 'rails_helper'

RSpec.describe OfferItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :unit }
    it { should validate_presence_of :offer }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
  end

  describe "relations" do
    it { should belong_to :offer }
  end
end
