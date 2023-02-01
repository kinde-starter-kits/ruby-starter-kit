# README

The application represents simple rails app with [kinde_api](https://github.com/kinde-oss/kinde-ruby-sdk) gem usage.
For more details on how to work with the gem please refer to gem's homepage.
Here are some notes on implementation.

Installation and running just as simple as:
```
bundle
rails s
```
No database or other dependencies needed.

Basically, all the main logic lays in two files - initializer for the api gem and controller which is handling all the logic.
Please, be sure you are splitting and organizing your codebase more correct - splitting in different controllers and interactors, 
calling interactors instead of keeping all the logic in a controller etc.
Here is just an example of basic usage and not the real guide to code organization.

The [initializer](https://github.com/kinde-starter-kits/ruby-starter-kit/blob/main/config/initializers/kinde_api.rb)
contains setup code. It uses environment variables - you need to set in the
[.env file](https://github.com/kinde-starter-kits/ruby-starter-kit/blob/main/.env)
at least `KINDE_DOMAIN`, `KINDE_CLIENT_ID` and `KINDE_CLIENT_SECRET` to your real credentials to make it work.
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
