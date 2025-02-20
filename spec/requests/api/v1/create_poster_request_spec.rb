require 'rails_helper'

RSpec.describe Api::V1::PostersController, type: :controller do
  describe 'POST #create' do
    let(:valid_attributes) {
      {
        name: "DEFEAT",
        description: "It's too late to start now.",
        price: 35.00,
        year: 2023,
        vintage: false,
        img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
      }
    }

    context 'when the request is valid' do
      it 'creates a new poster and returns a JSON response' do
        post :create, params: valid_attributes

        expect(response.status).to eq(201)

        json_response = JSON.parse(response.body)

        expect(json_response['data']['attributes']['name']).to eq("DEFEAT")
        expect(json_response['data']['attributes']['description']).to eq("It's too late to start now.")
        expect(json_response['data']['attributes']['price']).to eq(35.00)
        expect(json_response['data']['attributes']['year']).to eq(2023)
        expect(json_response['data']['attributes']['vintage']).to eq(false)
        expect(json_response['data']['attributes']['img_url']).to eq("https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")
      end
    end
  end
end
