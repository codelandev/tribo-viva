class PagesController < ApplicationController
  def home
    @valid_offers    = Offer.valid_offers.order(created_at: :desc)
    @finished_offers = Offer.finished_offers.limit(6)
  end

  def about
  end
end
