class Api::V1::RegistrationsController < Devise::RegistrationsController
    before_action :ensure_params, only: :create

#sign up

def create
    user = User.new
    user = User.create!(user_params)

    if user.save
        json_response("Signed up successfully", true, user, :created)
    else
        json_response("Something wrond", false, { }, :unprocessable_entity)
    end
end

private
def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)    
end

def ensure_params
    return if params[:user].present?
    json_response("Missing params", false, {}, :bad_request )
end
end
