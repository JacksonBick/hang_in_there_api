require 'rails_helper'

describe "Posters API", type: :request do
  it "sends a list of posters" do
    Poster.create(name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: Time.now)

      Poster.create(name: "HOPELESSNESS",
      description: "Stay in your comfort zone; it's safer.",
      price: 112.00,
      year: 2020,
      vintage: true,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d",
      created_at: Time.now)
  
    get '/api/v1/posters'
  
    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body, symbolize_names: true)
  
    expect(json[:data].length).to eq(2)
  
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
    id = Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price: 89.00,
    year: 2018,
    vintage: true,
    img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d").id
  
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
  
    expect(response).to have_http_status(200)
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
    id = Poster.create!(
      name: "FUTILITY",
      description: "Hard work rarely pays off.",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    ).id
  
    poster_params = { 
      name: "REGRET", 
      description: "Updated description", 
      price: 150.00, 
      year: 2016, 
      vintage: false, 
      img_url: "https://example.com/updated_image.jpg" 
    }
  
    headers = { "CONTENT_TYPE" => "application/json" }
    
    patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({ poster: poster_params })
    
    updated_poster = Poster.find(id)
    
    expect(response).to be_successful
    expect(updated_poster.name).to eq("REGRET")
    expect(updated_poster.description).to eq("Updated description")
    expect(updated_poster.price).to eq(150.00)
    expect(updated_poster.year).to eq(2016)
    expect(updated_poster.vintage).to eq(false)
    expect(updated_poster.img_url).to eq("https://example.com/updated_image.jpg")
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

  it "returns a 422 error when the poster data is invalid #create" do
    invalid_poster_params = {
      name: "",  
      description: "Updated description",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url: "https://example.com/updated_image.jpg"
    }
  
    headers = { "CONTENT_TYPE" => "application/json" }
  
    post "/api/v1/posters", headers: headers, params: JSON.generate({ poster: invalid_poster_params })
  
    expect(response).to have_http_status(:unprocessable_entity)
  
    expect(response.body).to include("Name can't be blank")
  end
  
  it "returns a 422 error when the poster data is invalid #update" do
    poster = Poster.create!(
      name: "FUTILITY",
      description: "Hard work rarely pays off.",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
  
    invalid_poster_params = {
      name: "",
      description: "Updated description",
      price: 150.00,
      year: 2016,
      vintage: false,
      img_url: "https://example.com/updated_image.jpg"
    }
  
    headers = { "CONTENT_TYPE" => "application/json" }
  
    patch "/api/v1/posters/#{poster.id}", headers: headers, params: JSON.generate({ poster: invalid_poster_params })
  
    expect(response).to have_http_status(:unprocessable_entity)
  
    expect(response.body).to include("Name can't be blank")
  end
  
  
  

  it "returns a 404 error when the poster is not found" do
    invalid_id = 99999 
    
    headers = { "CONTENT_TYPE" => "application/json" }
  
    get "/api/v1/posters/#{invalid_id}", headers: headers
  
    expect(response).to have_http_status(:not_found)
  
    expect(response.body).to include("Record not found")
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

  it 'returns posters with price less than or equal to max_price' do
    Poster.create(name: "REGRET",
    description: "Hard work rarely pays off.",
    price:250.00,
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
    price: 500.00,
    year: 2020,
    vintage: true,
    img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

    get '/api/v1/posters', params: { max_price: 200 }

    json = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(json[:data].length).to eq(1)

    expect(json[:data].first[:attributes][:name]).to eq("FUTILITY")
  end
end