class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end

    def show
        render json: Poster.find(params[:id])
    end

    def create
  
        poster = Poster.new(poster_params)
      
        if poster.save
          render json: PosterSerializer.format_single_poster(poster, {})
        else
          render json: ErrorSerializer.format_error(422, poster.errors.full_messages.join(", ")), status: :unprocessable_entity
        end
    end
    
end