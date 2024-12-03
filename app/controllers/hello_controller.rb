class HelloController < ApplicationController
  before_action :init_mgmt_client, only: [:mgmt_index, :create_organization, :create_user]

  CLIENT_UNDEFINED_ALERT = "Please, log in before any actions"

  def index
  end

  def mgmt_index
  end

  def create_organization
    params = create_organization_params
    wrap_with_mgmt_client_checking do
      @client.organizations.create_organization(
        name: params[:name]
      )
    end
  end

  def create_user
    params = create_user_params
    wrap_with_mgmt_client_checking do
      @client.users.create_user(
        create_user_request: {
          profile: { given_name: params[:name], family_name: params[:surname] },
          identities: [{ type: "email", details: { email: params[:email] } }]
        }
      )
    end
  end

  private

  def wrap_with_mgmt_client_checking
    if @client.present?
      yield
      redirect_to mgmt_path
    else
      redirect_to mgmt_path, alert: CLIENT_UNDEFINED_ALERT
    end
  end

  def init_mgmt_client
    token = $redis.get("kinde_m2m_token")
    @client = KindeSdk.client({ "access_token" => token }) if token.present?
  end

  def create_user_params
    params.permit(:name, :surname, :email)
  end

  def create_organization_params
    params.permit(:name)
  end
end
