module CartClean
  extend ActiveSupport::Concern

  def clean
    session[:shopping_cart] = []
  end
end
