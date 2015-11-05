class ProducersController < ApplicationController
  def show
    @producer = Producer.find(params[:id])
  end
end
