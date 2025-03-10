class Api::V1::PostersController < ApplicationController
    def index
        if params[:sort]
            posters = Poster.sort_by_date(params[:sort])
            render json: PosterSerializer.new(posters, meta: { count: posters.size })
        else
            posters = Poster.index(params)
            
            render json: {
                data: PosterSerializer.new(posters).serializable_hash[:data],
                meta: { count: posters.size }
            }
        end
    end

    def show
        render json: PosterSerializer.new(Poster.find(params[:id]))
    end

    def create
        poster = Poster.create!(poster_params)
      
        render json: PosterSerializer.new(poster).serializable_hash, status: :created
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