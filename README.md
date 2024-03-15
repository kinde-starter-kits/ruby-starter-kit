# README

The application represents a simple Rails app with the [kinde-ruby-sdk](https://github.com/kinde-oss/kinde-ruby-sdk) gem usage.
For more details on how to work with the gem, please refer to the gem's homepage.
Here are some notes on implementation.

Installation and running are just as simple as:
```
bundle
rails s
```
The only external dependency you'll need is Redis, here is the [installation guide](https://redis.io/docs/getting-started/installation/install-redis-on-linux/).

Basically, all the main logic lays in several files:
- initializer for the api gem 
- `auth_controller` which is handling all the auth logic
- `hello_controller` which is handling client logic.
Some logic performed inside views, but please, be sure you are splitting and organizing your codebase more correct in a 
real work: different controllers, interactors, service classes, calling interactors instead of keeping all the logic in a controller or view etc.
Here is just an example of basic usage of gem and not the real guide to code organization.

The [initializer](https://github.com/kinde-starter-kits/ruby-starter-kit/blob/main/config/initializers/kinde_api.rb)
contains setup code. Rename the `.env.sample` file to `.env`. The initializer uses environment variables - you need to set in the
[.env file](https://github.com/kinde-starter-kits/ruby-starter-kit/blob/main/.env)
at least `KINDE_DOMAIN`, `KINDE_CLIENT_ID` and `KINDE_CLIENT_SECRET` to your real credentials to make it work.
`KINDE_MANAGEMENT_CLIENT_ID` and `KINDE_MANAGEMENT_CLIENT_SECRET` should be configured as well if you are going to use 
management API (organization handling as an example). They probably different from your main application credentials 
because for management meant to be used separate M2M application.
Also, be sure you are added `KINDE_CALLBACK_URL` and `KINDE_LOGOUT_URL` values to allowed in your Kinde management dashboard.
Usually it lays somewhere in settings -> applications -> <your application> -> details. And the client, secret and domain are refers to
field values from this panel too.

The app contains [auth_controller](https://github.com/kinde-starter-kits/ruby-starter-kit/blob/main/app/controllers/auth_controller.rb).
It is the main handler of all Kinde usage stuff:
- `#auth` used to generate url with code verifier, save verifier and redirect to the url which is authorization entry point.
- `#logout` is calling the logout endpoint and resets the session. 
- `#callback` used to process incoming Kinde callback with code. It fetches all the tokens, saves them, initializes client, 
calling one of the description Kinde's endpoint and saves user's details.
- `logout_callback` used to process logout incoming callback from Kinde. Here is just some random logging line, but in real
usage it might be some cache clearing or else.
- `client_credentials_auth` is used to fetch access token for management API. Instead of authorization code grant type with 
code exchanging it uses client credentials grant type which is looks more like basic auth. 
Note that this token saved in redis - this is example of another storage usage.

In addition, ruby-starter-kit application contains [hello_controller](https://github.com/kinde-starter-kits/ruby-starter-kit/blob/main/app/controllers/hello_controller.rb)
for handling client usage stuff. Some logic lays inside the controller itself, some extracted into `application_helper` or related `hello`-views.
