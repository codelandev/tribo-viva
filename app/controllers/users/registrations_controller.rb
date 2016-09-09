class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    ab_finished(:communication_style)
  end

  protected

  def after_sign_up_path_for(resource)
    stored_location_for(:user) || super
  end
end
