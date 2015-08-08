class PagesController < ApplicationController
  def home
    @valid_offers    = Offer.valid_offers.order(collect_starts_at: :asc)
    @finished_offers = Offer.finished_offers.order(collect_starts_at: :desc)
  end

  def about
  end

  def cart
  end

  def terms
  end
end
