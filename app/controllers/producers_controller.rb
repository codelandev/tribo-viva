class ProducersController < ApplicationController
  def show
    @producer = Producer.find(params[:id])
  end

  def index
    @producers = Producer.all
  end
end
