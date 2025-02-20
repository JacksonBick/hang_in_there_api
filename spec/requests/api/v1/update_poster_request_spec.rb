require "rails_helper"

describe "update poster", type: :request do
    it "will update the poster" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        patch "/api/v1/posters/#{regret.id}", params: { price: 100.00 } 
        
        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        updated_poster = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(updated_poster[:id]).to be_a(String)
        expect(updated_poster[:type]).to eq("poster")

        attrs = updated_poster[:attributes]

        expect(attrs[:name]).to be_a(String)
        expect(attrs[:description]).to be_a(String)
        expect(attrs[:price]).to be_a(Float)
        expect(attrs[:year]).to be_a(Integer)
        expect(attrs[:vintage]).to be_a(TrueClass)
        expect(attrs[:img_url]).to be_a(String)
        expect(attrs[:price]).to eq(100.00)
    end
end