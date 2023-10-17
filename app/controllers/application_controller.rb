class ApplicationController < ActionController::Base

    private

    def init_mgmt_client
        token = $redis.get("kinde_m2m_token")
        @client = KindeSdk.client({ "access_token" => token }) if token.present?
    end
end
