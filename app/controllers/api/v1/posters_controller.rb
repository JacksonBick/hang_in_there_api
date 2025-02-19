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
end