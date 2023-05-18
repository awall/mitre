class SentencesController < ApplicationController
  def index
    @sentences = Sentence.all
  end

  def show
    id = params.require(:id)
    @sentence = Sentence.includes(:entities).find(id)
  end
  
  def create_entity
    sentence_id = params.require(:sentence_id)
    text = params[:text]
    typ = params[:typ]
    Entity.create!(sentence_id: sentence_id, text: text, typ: typ)
    redirect_to request.referer
  end
end
