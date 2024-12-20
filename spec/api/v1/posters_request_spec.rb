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

  it "can create a poster" do
    poster_params = {
      name: "Test",
      description: "Expected",
      price: 999.00,
      year: 1994,
      vintage: true,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    }
  
    headers = { "CONTENT_TYPE" => "application/json" }
  
    post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
    created_poster = Poster.last
  
    expect(response).to be_successful
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

  it "can update a poster" do
    id = Poster.create(
      name: "FUTILITY",
      description: "Hard work rarely pays off.",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    ).id
    previous_name = Poster.last.name
    poster_params = { name: "REGRET"}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
    poster = Poster.find_by(id: id)

    expect(response).to be_successful
    expect(poster.name).to_not eq(previous_name)
    expect(poster.name).to eq("REGRET")
  end

  it "can destroy an poster" do
    poster = Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")


    expect(Poster.count).to eq(1)

    delete "/api/v1/posters/#{poster.id}"

    expect(response).to be_successful
    expect(Poster.count).to eq(0)
    expect{ Poster.find(poster.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "sorts the posters from created_at ascending" do
      Poster.create(name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 1)

      Poster.create(name: "FUTILITY",
      description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 2)

      Poster.create(name: "HOPELESSNESS",
      description: "Stay in your comfort zone; it's safer.",
      price: 112.00,
      year: 2020,
      vintage: true,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 3)

      get '/api/v1/posters', params: { sort: 'asc' }

      expect(response).to be_successful

      posters = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(posters.first[:attributes][:name]).to eq("REGRET")
      expect(posters.last[:attributes][:name]).to eq("HOPELESSNESS")
  end
  
  it "sorts the posters from created_at descending" do
    Poster.create(name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 1)

      Poster.create(name: "FUTILITY",
      description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 2)

      Poster.create(name: "HOPELESSNESS",
      description: "Stay in your comfort zone; it's safer.",
      price: 112.00,
      year: 2020,
      vintage: true,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 3)
      
      get '/api/v1/posters', params: { sort: 'desc' }

      expect(response).to be_successful

      posters = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(posters.first[:attributes][:name]).to eq("HOPELESSNESS")
      expect(posters.last[:attributes][:name]).to eq("REGRET")
      
  end

  it "filters posters by specific name endpoint" do
    Poster.create(name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 1)

      Poster.create(name: "FUTILITY",
      description: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: 2)

      get '/api/v1/posters', params: { name: "FUTILITY" }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:success)
      expect(json[:data].first[:attributes][:name]).to eq("FUTILITY")
  end

  it "filters posters by min_price" do
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

    Poster.create(name: "HOPELESSNESS",
    description: "Stay in your comfort zone; it's safer.",
    price: 112.00,
    year: 2020,
    vintage: true,
    img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    get '/api/v1/posters', params: { min_price: 100 }

    expect(response).to have_http_status(:success)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(2)
    expect(json[:data].first[:attributes][:name]).to eq("FUTILITY")
  end
end