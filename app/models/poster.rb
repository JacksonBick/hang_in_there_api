class Poster < ApplicationRecord
    def self.index(params)
        queryResult = nil
        
        if params["name"]
            queryResult = Poster.where("name like ?", "%#{params['name'].upcase}%")
        else
            queryResult = Poster.all
        end

        PosterSerializer.new(queryResult)
    end
end