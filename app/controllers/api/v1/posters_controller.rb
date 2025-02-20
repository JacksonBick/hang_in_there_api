class Api::V1::PostersController < ApplicationController
    def index
        render json: {
            data: Poster.all
        }
    end

    def show
        render json: {
            data: Poster.find(params[:id])
        }
    end

    def update
        poster = Poster.find(params[:id])
        poster.update!(poster_params)
        render json: PosterSerializer.new(poster)
    end

    def destroy
        poster = Poster.find(params[:id])
        poster.destroy
    end

    # this will make the params strong and will only allow
    # primited attrubutes allowed to be change

    private 

    def poster_params
        params.permit(:name, :description, :year, :vintage, :img_url, :price)
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