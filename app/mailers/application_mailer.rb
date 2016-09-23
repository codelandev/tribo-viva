class ApplicationMailer < ActionMailer::Base
  default from: 'tribo@triboviva.com.br'
  layout 'mailer'
  before_action :add_inline_attachments!

  private

  def add_inline_attachments!
    attachments.inline['logo.png'] =
      Rails.root.join('app/assets/images/logo-triboviva.png').read
  end
end
