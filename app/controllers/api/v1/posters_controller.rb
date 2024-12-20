class Api::V1::PostersController < ApplicationController
  def index
    posters = sorted_posters
    option = { meta: { count: posters.count } }
    render json: PosterSerializer.format_posters(posters, option)
  end
  

  def show
    poster = Poster.find(params[:id])
    option = {}
    render json: PosterSerializer.format_single_poster(poster, option)
  end

  def create
    poster = Poster.create(poster_params)
    render json: PosterSerializer.format_single_poster(poster, {}) 
  end

  def update
    poster = Poster.update(params[:id], poster_params)
    render json: PosterSerializer.format_single_poster(poster, {})
  end

  def destroy
    poster = Poster.delete(params[:id])
  end

  private

  def sorted_posters
    if params[:sort] == 'desc'
      sort_order = 'desc'
    else
      sort_order = 'asc'
    end

    Poster.order(created_at: sort_order)
  end
end

private

def poster_params
  params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
end