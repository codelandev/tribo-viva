require 'rails_helper'

RSpec.describe UserSignUpJob, type: :job do
  describe 'perform' do
    let!(:user) { User.make!(name: 'some name', cpf: '012.345.678-90') }
    let!(:expected_id) { '77C2565F6F064A26ABED4255894224F0' }

    before do
      body = {
        cpf_cnpj: '01234567890',
        email: user.email,
        name: 'some name'
      }.to_json
      body_response = {
        id: expected_id,
        email: user.email,
        name: user.name,
        notes: "",
        created_at: "2015-11-18T14:58:30-02:00",
        updated_at: "2015-11-18T14:58:30-02:00",
        custom_variables: []
      }.to_json
      stub_request(:post, "https://#{Rails.application.secrets.iugu_api_key}:@api.iugu.com/v1/customers").
        with({
        body: body,
        headers: {
          accept: 'application/json',
          accept_charset: 'utf-8',
          accept_encoding: 'gzip, deflate',
          accept_language: 'pt-br;q=0.9,pt-BR',
          content_length: body.size,
          content_type: 'application/json; charset=utf-8',
          user_agent: 'Iugu RubyLibrary'
        }}).to_return(status: 201, body: body_response)
    end

    it 'changes user#iugu_customer with customer id' do
      expect{ subject.perform(user) }.to change(user, :iugu_customer).from(nil).to(expected_id)
    end
  end
end
