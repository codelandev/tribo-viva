class Users::SessionsController < Devise::SessionsController
  def destroy
    # Avoid to clean shopping cart when devise sign_out
    shopping_cart = session[:shopping_cart]
    super
    session[:shopping_cart] = shopping_cart
  end

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(:user) || super
  end
end
