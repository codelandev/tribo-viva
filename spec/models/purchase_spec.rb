require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of :token }
    it { is_expected.to validate_presence_of :total }
    it { is_expected.to validate_presence_of :status }
    it { is_expected.to validate_presence_of :user_id }
  end

  describe 'Relations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end
end
