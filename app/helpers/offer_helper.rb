module OfferHelper
  def progress_bar_percentage(offer)
    current = offer.stock - offer.remaining
    total = offer.stock.to_f
    total = ((current / total) * 100).to_i
    [0, [100, total].min].max
  end
end
