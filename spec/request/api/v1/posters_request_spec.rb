
require 'rails_helper'


describe "Posters api" do
  it "sends posters" do
    Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    Poster.create(name: "FUTILITY",
    description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
    price: 150.00,
    year: 2016,
    vintage: false,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    get '/api/v1/posters'

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)

    expect(posters.count).to eq(3)

    posters.each do |poster|
        expect(poster).to have_key(:id)
        expect(poster[:id]).to be_an(Integer)

        expect(poster).to have_key(:type)
        expect(poster).to have_key(:name)
        expect(poster).to have_key(:description)
        expect(poster).to have_key(:price)
        expect(poster).to have_key(:vintage)
        expect(poster[:type]).to be_a(String) 
        expect(poster[:name]).to be_a(String)
        expect(poster[:description]).to be_a(String)
        expect(poster[:price]).to be_a(Float)
        expect(poster[:vintage]).to be_a(String)

    end
  end
end

describe "test for asc" do
    it "sorts the posters from created_at ascending" do
        get '/api/v1/posters', params: { sort: 'asc' }

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(posters.first[:attributes][:name]).to eq("HOPELESSNESS")
        expect(posters.last[:attributes][:name]).to eq("REGRET")
    end
end

describe "test for desc" do
    it "sorts the posters from created_at descending" do
        get '/api/v1/posters', params: { sort: 'desc' }

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(posters.first[:attributes][:name]).to eq("REGRET")
        expect(posters.last[:attributes][:name]).to eq("HOPELESSNESS")
    end
end
