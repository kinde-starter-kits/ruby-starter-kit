class AuthController < ApplicationController
  def auth
    auth = KindeApi.auth_url
    session[:code_verifier] = auth[:code_verifier]
    redirect_to auth[:url], allow_other_host: true
  end

  def callback
    session[:kinde_auth] =
      KindeApi
        .fetch_tokens(params["code"], session[:code_verifier])
        .slice(:access_token, :refresh_token, :expires_at)

    user_profile = KindeApi.client(session[:kinde_auth]["access_token"]).oauth.get_user
    session[:kinde_user] = user_profile.to_hash

    redirect_to root_path
  end

  def logout
    KindeApi.logout(session[:kinde_auth]["access_token"])
    reset_session
    redirect_to root_path
  end

  def logout_callback
    Rails.logger.info("logout callback successfully received")
  end
end
