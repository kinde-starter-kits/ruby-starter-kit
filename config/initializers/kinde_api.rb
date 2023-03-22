KindeApi.configure do |c|
  c.domain = ENV["KINDE_DOMAIN"]
  c.client_id = ENV["KINDE_CLIENT_ID"]
  c.client_secret = ENV["KINDE_CLIENT_SECRET"]
  c.callback_url = ENV["KINDE_CALLBACK_URL"]
  c.logout_url = ENV["KINDE_LOGOUT_URL"]
  c.logger = Rails.logger
  c.debugging = true
  c.pkce_enabled = true
end
