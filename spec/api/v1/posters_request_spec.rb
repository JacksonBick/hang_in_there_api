require 'rails_helper'

describe "Posters API", type: :request do
  it "sends a list of posters" do
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

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(3)

    json[:data].each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(Integer)

      expect(poster).to have_key(:type)
      expect(poster[:type]).to eq("Poster")

      expect(poster).to have_key(:attributes)
      attributes = poster[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:price)
      expect(attributes[:price]).to be_a(Float)

      expect(attributes).to have_key(:year)
      expect(attributes[:year]).to be_a(Integer)

      expect(attributes).to have_key(:vintage)
      expect([true, false]).to include(attributes[:vintage])

      expect(attributes).to have_key(:img_url)
      expect(attributes[:img_url]).to be_a(String)
    end
  end

  it "can get one poster by its id" do
    id = Poster.create(
      name: "FUTILITY",
      description: "Hard work rarely pays off.",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    ).id
  
    get "/api/v1/posters/#{id}"
  
    response_body = JSON.parse(response.body, symbolize_names: true)
    poster = response_body[:data]
  
    expect(poster).to have_key(:id)
    expect(poster[:id]).to be_a(Integer)
  
    expect(poster).to have_key(:type)
    expect(poster[:type]).to eq("Poster")
  
    expect(poster).to have_key(:attributes)
    attributes = poster[:attributes]
  
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  
    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)
  
    expect(attributes).to have_key(:price)
    expect(attributes[:price]).to be_a(Float)
  
    expect(attributes).to have_key(:year)
    expect(attributes[:year]).to be_a(Integer)
  
    expect(attributes).to have_key(:vintage)
    expect([true, false]).to include(attributes[:vintage])
  
    expect(attributes).to have_key(:img_url)
    expect(attributes[:img_url]).to be_a(String)
  end

end