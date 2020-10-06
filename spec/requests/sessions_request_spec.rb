require 'rails_helper'

RSpec.describe "Sessions", type: :request do
    let(:user) { create(:user) }
    let(:valid_params) { { sign_in: { email: user.email, password: user.password } } }
    let(:valid_headers) { { "AUTH-TOKEN" => user.authentication_token } }

    describe 'POST /sign_in' do

        context 'user exists' do

            context 'valid password' do
                before { post "/api/v1/sign_in", params: valid_params }

                it 'log_in user propely' do
                    expect(json).to include("messages" => "Signed in properly")
                end

                it 'have http status 200' do
                    expect(response).to have_http_status(200)
                end

                it "create authentication token" do
                    expect(user.authentication_token).not_to be_nil
                    expect(json["data"]).not_to be_nil
                end

            end

            context 'invalid password' do
                before { post "/api/v1/sign_in", params: { sign_in: { email: user.email, password: "incorrect_for_sure" } } }

                it 'return failure message' do
                    expect(json).to include("messages" => "Wrong password or email")
                end

                it 'have http status unauthorized' do
                    expect(response).to have_http_status(401)
                end

                it 'does not sign_in user' do
                    expect(json["data"]).to be_empty
                end
            end

        end

        context 'user does not exist' do
             let(:invalid_user) { { sign_in: { email: "not@correct.com" } } }
            before { post "/api/v1/sign_in", params: invalid_user }
        

            it 'return failure message' do
                expect(json).to include("messages" => "Couldn't find User")
            end

            it "have http status not_found" do
                expect(response).to have_http_status(404)
            end

            it 'does not sign_in user' do
                expect(json["data"]).to be_empty
            end
        end
    end

    describe 'POST /sign_out' do
        
        context 'valid token' do
            before { delete "/api/v1/log_out", headers: valid_headers }

            it 'sign_out user' do
                expect(json["data"]).to be_empty
            end

            it 'have http status 200' do
                expect(response).to have_http_status(200)
            end

            it 'return success message' do
                expect(json["messages"]).to eq("Log out properly")
            end

            it 'create new auth token' do
                expect(user.authentication_token).not_to eq(headers["AUTH-TOKEN"])
            end
        end

        context 'invalid token' do
            before { delete "/api/v1/log_out", headers: {'AUTH-TOKEN' => "incorrect"} }

            it 'return failure message' do
                expect(json["messages"]).to eq("Invalid Token")
            end

            it 'have http status 401' do
                expect(response).to have_http_status(401)
            end
        end
    end
end
