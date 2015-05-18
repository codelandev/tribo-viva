require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  describe "validations" do
    it  { should validate_presence_of :cc }
    it  { should validate_presence_of :bank }
    it  { should validate_presence_of :agency }
    it  { should validate_presence_of :bank_number }
    it  { should validate_presence_of :operation_code }
  end

  describe "relations" do
    it { should have_many :offers }
  end
end
