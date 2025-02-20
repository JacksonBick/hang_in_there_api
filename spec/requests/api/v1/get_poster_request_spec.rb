require "rails_helper"

describe "get poster", type: :request do
    it "Can get all posters" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        futility = Poster.create(
            name: "FUTILITY",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 150.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get "/api/v1/posters"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        posters = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(posters.count).to eq(2)
        posters.each do |poster|
            poster = poster[:attributes]
            expect(poster[:name]).to be_a(String)
            expect(poster[:description]).to be_a(String)
            expect(poster[:price]).to be_a(Float)
            expect(poster[:year]).to be_a(Integer)
            expect(poster[:vintage]).to be_in([true, false])
            expect(poster[:img_url]).to be_a(String)
            expect(poster[:price]).to be_a(Float)
        end
    end

    it "can get a single poster" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get "/api/v1/posters/#{regret.id}"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        poster = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

        expect(poster[:name]).to be_a(String)
        expect(poster[:description]).to be_a(String)
        expect(poster[:price]).to be_a(Float)
        expect(poster[:year]).to be_a(Integer)
        expect(poster[:vintage]).to be_in([true, false])
        expect(poster[:img_url]).to be_a(String)
        expect(poster[:price]).to be_a(Float)
    end

    it "Can filter returned results by name" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        futility = Poster.create(
            name: "FUTILITY",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 150.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        failure = Poster.create(
            name: "FAILURE",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 150.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get "/api/v1/posters?name=r"

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(posters.count).to eq(2)
        
        posterNames = posters.map do |poster|
            poster[:attributes][:name]
        end

        expect(posterNames).to include("FAILURE")
        expect(posterNames).to include("REGRET")
    end

    it "Can return all posters below a given price" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        futility = Poster.create(
            name: "FUTILITY",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 150.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        failure = Poster.create(
            name: "FAILURE",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 100.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get "/api/v1/posters?max_price=100"

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(posters.count).to eq(2)
        
        posterNames = posters.map do |poster|
            poster[:attributes][:name]
        end

        expect(posterNames).to include("FAILURE")
        expect(posterNames).to include("REGRET")
    end

    it "Can return all posters above a given price" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        futility = Poster.create(
            name: "FUTILITY",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 150.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )
        failure = Poster.create(
            name: "FAILURE",
            description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
            price: 100.0,
            year: 2016,
            vintage: false,
            img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        get "/api/v1/posters?min_price=100"

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(posters.count).to eq(2)
        
        posterNames = posters.map do |poster|
            poster[:attributes][:name]
        end

        expect(posterNames).to include("FAILURE")
        expect(posterNames).to include("FUTILITY")
    end
end