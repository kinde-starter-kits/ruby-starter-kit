class AuthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:callback, :sign_up, :auth, :logout]

  def auth
    auth = KindeSdk.auth_url
    session[:code_verifier] = auth[:code_verifier] if auth[:code_verifier].present?
    redirect_to auth[:url], allow_other_host: true
  end

  def sign_up
    auth = KindeSdk.auth_url(start_page: "registration")
    session[:code_verifier] = auth[:code_verifier] if auth[:code_verifier].present?
    redirect_to auth[:url], allow_other_host: true
  end

  def callback
    session[:kinde_auth] =
      KindeSdk
        .fetch_tokens(params["code"], code_verifier: KindeSdk.config.pkce_enabled ? session[:code_verifier] : nil)
        .slice(:access_token, :refresh_token, :expires_at)

    user_profile = KindeSdk.client(session[:kinde_auth]).oauth.get_user
    session[:kinde_user] = user_profile.to_hash
    client_credentials_auth
    redirect_to root_path
  end

  

  def logout
    redirect_to KindeSdk.logout_url, allow_other_host: true
  end

  def logout_callback
    Rails.logger.info("logout callback successfully received")
    reset_session
    redirect_to root_path
  end

  private

  def client_credentials_auth
    result = KindeSdk.client_credentials_access(
      client_id: ENV["KINDE_MANAGEMENT_CLIENT_ID"],
      client_secret: ENV["KINDE_MANAGEMENT_CLIENT_SECRET"]
    )
    raise result if result["error"].present?

    $redis.set("kinde_m2m_token", result["access_token"], ex: result["expires_in"].to_i)
  end
end
