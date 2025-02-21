require "rails_helper"

describe "Query Params", type: :request do
    it "will sort Posters by ascending created at date" do
        poster1 = Poster.create(
            name: "poster1",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        poster2 = Poster.create(
            name: "poster2",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        poster3 = Poster.create(
            name: "poster3",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get '/api/v1/posters', params: { sort: "asc" }

        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        sorted_posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(sorted_posters).to be_a(Array)
        expect(sorted_posters.first[:attributes][:name]).to eq(poster1.name)
        expect(sorted_posters.last[:attributes][:name]).to eq(poster3.name)
    end

    it "will sort Posters by descending created at date" do
        poster1 = Poster.create(
            name: "poster1",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        poster2 = Poster.create(
            name: "poster2",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        poster3 = Poster.create(
            name: "poster3",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get '/api/v1/posters', params: { sort: "desc" }

        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        sorted_posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(sorted_posters).to be_a(Array)
        expect(sorted_posters.first[:attributes][:name]).to eq(poster3.name)
        expect(sorted_posters.last[:attributes][:name]).to eq(poster1.name)

        count = JSON.parse(response.body, symbolize_names: true)[:meta][:count]

        expect(count).to eq(3)

    end
end