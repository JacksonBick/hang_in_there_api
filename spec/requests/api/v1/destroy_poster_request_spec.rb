require "rails_helper"

describe "destroy poster", type: :request do
    it "will destroy the poster" do
        regret = Poster.create(
            name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
        )

        delete "/api/v1/posters/#{regret.id}"
        
        expect(response).to be_successful
        expect(response.status).to eq(204)
    end
end