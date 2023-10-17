class UsersController < ApplicationController
    before_action :init_mgmt_client, only: [:create]

    KINDE_ERROR = "Error from Kinde"
    
    def new
    end

    def show_user
      @user = JSON.parse(params[:user])
    end
    
    def create
      begin
        create_user
        redirect_to show_user_users_path(user: @user.to_json)
      rescue => e
        flash[:error] = "#{KINDE_ERROR}-#{e}"
        render new_user_path
      end
    end
  
    private
    
    def create_user
      params = create_user_params
      @user = @client.users.create_user(
        create_user_request: {
          profile: { given_name: params[:name], family_name: params[:surname] },
          identities: [{ type: "email", details: { email: params[:email] } }]
        }
      )
    end

  
    def create_user_params
      params.permit(:name, :surname, :email)
    end
end
  