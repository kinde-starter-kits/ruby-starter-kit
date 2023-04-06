class AuthController < ApplicationController
  def auth
    auth = KindeSdk.auth_url
    session[:code_verifier] = auth[:code_verifier] if auth[:code_verifier].present?
    redirect_to auth[:url], allow_other_host: true
  end

  def callback
    session[:kinde_auth] =
      KindeSdk
        .fetch_tokens(params["code"], KindeSdk.config.pkce_enabled ? session[:code_verifier] : nil)
        .slice(:access_token, :refresh_token, :expires_at)

    user_profile = KindeSdk.client(session[:kinde_auth]["access_token"]).oauth.get_user
    session[:kinde_user] = user_profile.to_hash

    redirect_to root_path
  end

  def client_credentials_auth
    result = KindeSdk.client_credentials_access(
      client_id: ENV["KINDE_MANAGEMENT_CLIENT_ID"],
      client_secret: ENV["KINDE_MANAGEMENT_CLIENT_SECRET"]
    )
    $redis.set("kinde_m2m_token", result["access_token"], ex: result["expires_in"].to_i)

    redirect_to mgmt_path
  end

  def logout
    KindeSdk.logout(session[:kinde_auth]["access_token"])
    reset_session
    redirect_to root_path
  end

  def logout_callback
    Rails.logger.info("logout callback successfully received")
  end
end
