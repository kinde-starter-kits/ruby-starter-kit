class HelloController < ApplicationController
  before_action :init_mgmt_client, only: [:mgmt_index, :create_organization]
  skip_before_action :authenticate_user!, only: [:index]
  
  CLIENT_UNDEFINED_ALERT = "Please, log in before any actions"

  def index
  end

  def mgmt_index
  end

  def create_organization
    params = create_organization_params
    # might be `@client.organizations.create_organization(create_organization_request: {name: "new_org"})` as well
    wrap_with_mgmt_client_checking do
      @client.organizations.create_organization(
        create_organization_request: KindeApi::CreateOrganizationRequest.new(name: params[:name])
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

  def create_organization_params
    params.permit(:name)
  end
end
