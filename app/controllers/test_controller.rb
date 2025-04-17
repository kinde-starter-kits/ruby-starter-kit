class TestController < ApplicationController
  include ApplicationHelper
  before_action :check_login

  def refresh_token
    begin
      new_tokens = KindeSdk.refresh_token(session[:kinde_auth])
      flash[:success] = "Token refreshed successfully! New expiration: #{Time.at(new_tokens['expires_at']).strftime('%Y-%m-%d %H:%M:%S')}"
    rescue => e
      flash[:error] = "Failed to refresh token: #{e.message}"
    end
    redirect_to root_path
  end

  def token_expired
    expired = KindeSdk.token_expired?(session[:kinde_auth])
    flash[:info] = "Token is #{expired ? 'expired' : 'not expired'}. Expiration time: #{Time.at(session[:kinde_auth]['expires_at']).strftime('%Y-%m-%d %H:%M:%S')}"
    redirect_to root_path
  end

  def test_client
    begin
      client = KindeSdk.client(session[:kinde_auth])
      flash[:success] = "Client instantiated successfully! Access token: #{client.bearer_token[0..10]}..."
    rescue => e
      flash[:error] = "Failed to instantiate client: #{e.message}"
    end
    redirect_to root_path
  end

  def get_claim
    begin
      client = KindeSdk.client(session[:kinde_auth])
      claim = params[:claim]
      claim_value = client.get_claim(claim)
      
      if claim_value
        flash[:success] = "Claim '#{claim}' value: #{claim_value[:value].inspect}"
      else
        flash[:warning] = "Claim '#{claim}' not found in token"
      end
    rescue => e
      flash[:error] = "Failed to get claim: #{e.message}"
    end
    redirect_to root_path
  end

  private

  def check_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this page"
      redirect_to "/kinde_sdk/auth"
    end
  end
end 