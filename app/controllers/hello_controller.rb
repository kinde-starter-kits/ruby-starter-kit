class HelloController < ApplicationController
  include ApplicationHelper
  before_action :init_mgmt_client, only: [:mgmt_index, :create_organization, :create_user]
  #before_action :check_login

  CLIENT_UNDEFINED_ALERT = "Please, log in before any actions"

  def index
  end

  def mgmt_index
  end

  def create_organization
    return redirect_with_error("No valid session found") unless logged_in?

    params = create_organization_params
    wrap_with_mgmt_client_checking do
      @client.organizations.create_organization(
        create_organization_request: KindeApi::CreateOrganizationRequest.new(name: params[:name])
      )
      flash[:success] = "Organization created successfully"
    end
  rescue StandardError => e
    handle_error("Failed to create organization", e)
  end

  def create_user
    return redirect_with_error("No valid session found") unless logged_in?

    params = create_user_params
    wrap_with_mgmt_client_checking do
      @client.users.create_user(
        create_user_request: {
          profile: { given_name: params[:name], family_name: params[:surname] },
          identities: [{ type: "email", details: { email: params[:email] } }]
        }
      )
      flash[:success] = "User created successfully"
    end
  rescue StandardError => e
    handle_error("Failed to create user", e)
  end

  private

  def wrap_with_mgmt_client_checking
    if @client.present?
      yield
      redirect_to mgmt_path
    else
      redirect_with_error(CLIENT_UNDEFINED_ALERT)
    end
  end

  def init_mgmt_client
    token = $redis.get("kinde_m2m_token")
    @client = KindeSdk.client({ "access_token" => token }) if token.present?
  rescue StandardError => e
    Rails.logger.error("Failed to initialize management client: #{e.message}")
    @client = nil
  end

  def create_user_params
    params.permit(:name, :surname, :email)
  end

  def create_organization_params
    params.permit(:name)
  end

  def check_login
    unless session_present_in?
      flash[:error] = "Your session has expired"
      redirect_to "/"
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
