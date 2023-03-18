class HelloController < ApplicationController
  before_action :init_mgmt_client, only: [:mgmt_index, :create_organization]

  def index
  end

  def mgmt_index
  end

  def create_organization
    @client.organizations.create_organization(create_organization_request: KindeSdk::CreateOrganizationRequest.new(name: params[:name]))

    redirect_to mgmt_path
  end

  private

  def init_mgmt_client
    @client = KindeApi.client($redis.get("kinde_m2m_token"))
  end
end
