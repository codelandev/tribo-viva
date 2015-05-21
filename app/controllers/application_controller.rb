class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def record_not_found
    render 'pages/404', status: :not_found
  end

  def user_not_authorized
    flash[:error] = "Você não tem permissão para fazer isso."
    redirect_to(request.referrer || root_path)
  end
end
