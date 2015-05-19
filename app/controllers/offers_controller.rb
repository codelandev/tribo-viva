class OffersController < ApplicationController
  helper_method :resource
  def show;end

  protected

  def resource
    @offer ||= Offer.find(params[:id])
  end
end
