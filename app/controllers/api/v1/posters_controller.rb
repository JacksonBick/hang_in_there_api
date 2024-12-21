class Api::V1::PostersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

  def index
    posters = sorted_posters
    option = { meta: { count: posters.count } }
    render json: PosterSerializer.format_posters(posters, option)
  end
  

  def show
    poster = Poster.find_by(id: params[:id])

    if poster
      render json: PosterSerializer.format_single_poster(poster, {})
    else
      render json: ErrorSerializer.format_error(404, "Record not found"), status: :not_found
    end
  end

  def create
  
    poster = Poster.new(poster_params)
  
    if poster.save
      render json: PosterSerializer.format_single_poster(poster, {})
    else
      render json: ErrorSerializer.format_error(422, poster.errors.full_messages.join(", ")), status: :unprocessable_entity
    end
  end

  def update
    poster = Poster.find_by(id: params[:id])
    if poster.update(poster_params)
      render json: PosterSerializer.format_single_poster(poster, {}), status: :ok
    else
      render json: ErrorSerializer.format_error(422, poster.errors.full_messages), status: :unprocessable_entity
    end
  end

  def destroy
    poster = Poster.delete(params[:id])
  end

  private

  def sorted_posters
    sort_order = params[:sort] == 'desc' ? 'desc' : 'asc'
      posters = Poster.order(created_at: sort_order)
      posters
  end

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end