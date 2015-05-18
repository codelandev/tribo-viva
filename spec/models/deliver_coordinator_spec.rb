require 'rails_helper'

RSpec.describe DeliverCoordinator, type: :model do
  describe "validations" do
    it { should validate_presence_of :cpf }
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :email }
    it { should validate_presence_of :avatar }
    it { should validate_presence_of :address }
  end
end
