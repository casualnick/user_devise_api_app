require 'rails_helper'

RSpec.describe "Registrations", type: :request do
    let(:valid_params) { { user: { email: 'host@email.com', password: 'password', password_confirmation: 'password' } } }

    describe 'POST /sign_up' do

        context 'params are invalid' do
            before { post "/api/v1/sign_up", params: { user: { email: "no_correct", password: "itis" } } }

            it "return failure message" do
                expect(json).to include("messages" => "Something's wrong")
            end

            it 'have http status 422' do
                expect(response).to have_http_status(422)
            end

            it 'does not create user' do
                expect(json).to include("data" => { })
            end
        end

        context 'valid params' do
            before { post "/api/v1/sign_up", params: valid_params }

            it ' creates user properly ' do
                expect(json.size).to eq(3)
            end

            it ' return success message ' do
                expect(json).to include("messages" => "Signed up successfully")
            end

            it 'have http status 201' do
                expect(response).to have_http_status(201)
            end

        end

        context "params are missing" do
            before { post "/api/v1/sign_up", params: { email: " ", password: " " } }

            it "return missing params message" do
                expect(json).to include("messages" => "Missing params")
            end

            it "have http status code 400" do
                expect(response).to have_http_status(400)
            end
        end

    end


end
