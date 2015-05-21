class OffersController < ApplicationController
  def show
    @offer = Offer.find(params[:id])
  end
end
