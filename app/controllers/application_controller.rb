class ApplicationController < ActionController::Base

    before_action :authenticate_user!

    protected
    def init_mgmt_client
        token = $redis.get("kinde_m2m_token")
        @client = KindeSdk.client({ "access_token" => token }) if token.present?
    end

    def authenticate_user!
        if session[:kinde_auth].present? && !KindeSdk.token_expired?(session[:kinde_auth])
            true
        else
            redirect_to root_path         
        end
    end
end        