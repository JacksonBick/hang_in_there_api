class Api::V1::PostersController < ApplicationController
  def index
   posters = Poster.all
   render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_single_poster(poster)
  end

  def create
    poster = Poster.create(poster_params)
    render json: PosterSerializer.format_single_poster(poster) 
  end

  def update
    poster = Poster.update(params[:id], poster_params)
    render json: PosterSerializer.format_single_poster(poster)
  end

  def destroy
    poster = Poster.delete(params[:id])
  end
end

private

def poster_params
  params.require(:poster).permit(:name, :description, :price, :year, :vintage, :image_url)
end