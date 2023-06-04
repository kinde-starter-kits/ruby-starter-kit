class HelloController < ApplicationController
  before_action :init_mgmt_client, only: [:mgmt_index, :create_organization, :create_user]

  def index
  end

  def mgmt_index
  end

  def create_organization
    # might be `@client.organizations.create_organization(create_organization_request: {name: "new_org"})` as well
    @client.organizations.create_organization(
      create_organization_request: KindeApi::CreateOrganizationRequest.new(name: params[:name])
    )

    redirect_to mgmt_path
  end

  def create_user
    @client.users.create_user(
      create_user_request: {
        profile: { given_name: params[:name], family_name: params[:surname] },
        identities: [{ type: "email", details: { email: params[:email] } }]
      }
    )

    redirect_to mgmt_path
  end

  private

  def init_mgmt_client
    token = $redis.get("kinde_m2m_token")
    @client = KindeSdk.client({"access_token" => token}) if token.present?
  end
end
