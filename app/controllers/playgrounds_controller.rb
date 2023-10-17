class PlaygroundsController < ApplicationController
    before_action :init_mgmt_client, :set_default_value, only: [:get_flag]
  
    def index 
    end

    def get_flag
      @result = @client.get_flag(params[:flag_input],  {default_value: @default_value }, params[:flag_type])
      render json: { result: @result }
    end
    
    private

    def set_default_value
      if params[:flag_type] == 'b'
        @default_value = params[:flag_input_default] == 'true'
      else
        @default_value = params[:flag_input_default].send("to_#{params[:flag_type]}")
      end
    end
  
    def create_user_params
      params.permit(:name, :surname, :email)
    end
end
  