class EntitiesController < ApplicationController
  def create
    sentence_id = params.require(:sentence_id)
    text = params[:text]
    typ = params[:typ]
    Entity.create!(sentence_id: sentence_id, text: text, typ: typ)
    redirect_to request.referer
  end
end
