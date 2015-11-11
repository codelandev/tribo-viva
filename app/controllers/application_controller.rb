class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :cart_session

  protected

  def record_not_found
    render 'pages/404', status: :not_found
  end

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para fazer isso."
    redirect_to(request.referrer || root_path)
  end

  def store_location
    store_location_for(:user, request.path)
  end

  def cart_session
    @cart_session ||= CartSession.new(session)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:name, :cpf, :phone, :address]
  end
end
