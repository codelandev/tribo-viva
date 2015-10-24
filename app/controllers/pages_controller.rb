class PagesController < ApplicationController
  before_action :store_location, only: :cart

  def home
    @valid_offers    = Offer.valid_offers.order(collect_starts_at: :asc)
    @finished_offers = Offer.finished_offers.order(collect_starts_at: :desc).limit(6)
  end

  def about
  end

  def cart
  end

  def terms
  end

  def delivery
  end

  def finished_offers
    @finished_offers = Offer.finished_offers.order(collect_starts_at: :desc)
  end
end
