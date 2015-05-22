require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :cpf }
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    # it { should validate_uniqueness_of(:cpf).scoped_to(:email) }
    # it { should validate_uniqueness_of(:email).scoped_to(:cpf) }
  end

  describe "relations" do
    it { should have_many :purchases }
  end
end
