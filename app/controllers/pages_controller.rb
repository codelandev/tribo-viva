class PagesController < ApplicationController
  def home
    @valid_offers    = Offer.valid_offers
    @finished_offers = Offer.finished_offers
  end

  def about
  end
end
