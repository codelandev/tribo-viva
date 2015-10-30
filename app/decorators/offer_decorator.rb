class OfferDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def title_with_items
    "#{object.title} #{'('+object.offer_items.count.to_s+' itens)' if object.offer_items.any?}"
  end
end
