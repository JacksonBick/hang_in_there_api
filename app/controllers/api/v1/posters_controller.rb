class Api::V1::PostersController < ApplicationController
    def index
        render json: PosterSerializer.new(Poster.all)
    end

    def show
        render json: PosterSerializer.new(Poster.find(params[:id]))
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
end