class TestController < ApplicationController
  include ApplicationHelper
  before_action :check_login

  def refresh_token
    return redirect_with_error("No valid session found") unless logged_in?

    if refresh_session_tokens
      flash[:success] = "Token refreshed successfully! New expiration: #{Time.at(session[:kinde_token_store][:expires_at]).strftime('%Y-%m-%d %H:%M:%S')}"
    else
      flash[:error] = "Failed to refresh token"
    end
    redirect_to root_path
  rescue StandardError => e
    handle_error("Token refresh failed", e)
  end

  def token_expired
    return redirect_with_error("No valid session found") unless logged_in?

    expired = token_expired?
    flash[:info] = "Token is #{expired ? 'expired' : 'not expired'}. Expiration time: #{Time.at(get_client.token_store.expires_at).strftime('%Y-%m-%d %H:%M:%S')}"
    redirect_to root_path
  rescue StandardError => e
    handle_error("Token expiration check failed", e)
  end

  def test_client
    return redirect_with_error("No valid session found") unless logged_in?

    client = get_client
    flash[:success] = "Client instantiated successfully! Access token: #{client.bearer_token[0..10]}..."
    redirect_to root_path
  rescue StandardError => e
    handle_error("Client instantiation failed", e)
  end

  def get_claim
    return redirect_with_error("No valid session found") unless logged_in?

    client = get_client
    claim = params[:claim]
    claim_value = client.get_claim(claim)
    
    if claim_value
      flash[:success] = "Claim '#{claim}' value: #{claim_value[:value].inspect}"
    else
      flash[:warning] = "Claim '#{claim}' not found in token"
    end
    redirect_to root_path
  rescue StandardError => e
    handle_error("Failed to get claim", e)
  end

  private

  def check_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this page"
      redirect_to "/"
      return
    end

    if token_expired?
      flash[:error] = "Your session has expired"
      redirect_to "/kinde_sdk/refresh_token"
    end
  end

  def handle_error(message, error)
    Rails.logger.error("#{message}: #{error.message}")
    flash[:error] = "#{message}: #{error.message}"
    redirect_to root_path
  end

  def redirect_with_error(message)
    flash[:error] = message
    redirect_to root_path
  end
end 