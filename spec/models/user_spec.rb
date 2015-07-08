require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :cpf }
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :address }
  end

  describe "relations" do
    it { should have_many :purchases }
    it { should have_many :old_purchases }
  end
end
