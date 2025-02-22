class Poster < ApplicationRecord
    def self.all_posters(params)
        query_result = nil

        query_result = filter_by_query("name", "LIKE", "%#{params[:name].upcase}%") if params[:name]
        query_result = filter_by_query("price", ">=", params[:min_price]) if params[:min_price]
        query_result = filter_by_query("price", "<=", params[:max_price]) if params[:max_price]
        query_result = Poster.all if !query_result

        query_result.order(:name)
    end

    def self.sort_by_date(sort)
        order(created_at: sort.to_sym)
    end

    def self.filter_by_query(col, operator, filter)
        where("#{col} #{operator} ?", filter)
    end
end