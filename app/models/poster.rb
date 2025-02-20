class Poster < ApplicationRecord
    def self.index(params)
        queryResult = nil

        if params["name"]
            queryResult = Poster.where("name like ?", "%#{params['name'].upcase}%")
        elsif params["min_price"]
            queryResult = Poster.where("price > ?", params["min_price"])
        else
            queryResult = Poster.all
        end

        PosterSerializer.new(queryResult)
    end
end