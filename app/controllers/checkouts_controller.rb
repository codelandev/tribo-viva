class CheckoutsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :store_location

  def checkout
    authorize :checkout
  end

  def process_payment
    authorize :checkout
  end

  protected

  def user_not_authorized
    flash[:alert] = "Faça login para acessar esta página"
    redirect_to new_user_session_path
  end

  def store_location
    store_location_for(:user, request.path)
  end
end
