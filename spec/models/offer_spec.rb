require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :image }
    it { should validate_presence_of :value }
    it { should validate_presence_of :stock }
    it { should validate_presence_of :producer }
    it { should validate_presence_of :bank_account }
    it { should validate_presence_of :offer_ends_at }
    it { should validate_presence_of :operational_tax }
    it { should validate_presence_of :coordinator_tax }
    it { should validate_presence_of :collect_ends_at }
    it { should validate_presence_of :offer_starts_at }
    it { should validate_presence_of :collect_starts_at }
    it { should validate_presence_of :deliver_coordinator }
    it { should validate_presence_of :products_description }
  end

  describe "relations" do
    it { should belong_to :producer }
    it { should belong_to :bank_account }
    it { should belong_to :deliver_coordinator }
  end
end
