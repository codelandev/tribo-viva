require 'rails_helper'

RSpec.describe Producer, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :logo }
    it { should validate_presence_of :email }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :address }
    it { should validate_presence_of :description }
    it { should validate_presence_of :contact_name }
  end
end
