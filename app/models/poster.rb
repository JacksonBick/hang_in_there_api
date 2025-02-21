class Poster < ApplicationRecord
    def self.index(params)
        queryResult = nil

        if params["name"]
            queryResult = Poster.where("name like ?", "%#{params['name'].upcase}%")
        end
        if params["min_price"]
            queryResult = Poster.where("price >= ?", params["min_price"])
        end
        if params["max_price"]
            queryResult = Poster.where("price <= ?", params["max_price"])
        end
        if !queryResult
            queryResult = Poster.all
        end

        PosterSerializer.new(queryResult)
    end

    def self.sort_by_date(sort)
        order(created_at: sort.to_sym)
    end
end