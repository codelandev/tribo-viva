class PagesController < ApplicationController
  def home
    @valid_offers    = Offer.valid_offers.order(collect_starts_at: :asc)
    @finished_offers = Offer.finished_offers.order(collect_starts_at: :desc).limit(6)
  end

  def about
  end
end
