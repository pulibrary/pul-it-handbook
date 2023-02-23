# CAS Rails Integration

Central Authentication Service ([CAS](https://apereo.github.io/cas/)) is a service that we use to authenticate users with their Princeton credentials. These instructions are the steps to allow a Rails application to authenticate a user with our CAS via the `devise` and `omniauth-cas` gems.

You can also use [Shibboleth](https://github.com/pulibrary/pul-the-hard-way/blob/main/services/shibboleth.md) for similar purposes. Shibboleth provides its own benefits and we still don't know which one is best/preferred/recommended. But if you need CAS this page is for you.

One advantage of using CAS over Shibboleth is that you don't need to setup anything on your local machine or on the server to use it.


## General workflow
When integrating CAS via these instructions the general workflow of the application is more or less as follows:

* There is a button in the app to authenticate via CAS.
* When a user clicks on this button they are taken to the Princeton authentication page (e.g. `https://fed.princeton.edu/cas/login?service=x&url=y`). Notice that OmniAuth is smart enough to pass the correct parameters to our CAS server so that the authentication service knows what to do after a user enters their credentials.
* Upon authentication (username, password, and two-factor authentication) the CAS server will callback our application to an endpoint provided by OmniAuth (e.g. `http://yourapp/users/auth/cas/callback?url=...&ticket=...`)
* At this point OmniAuth will call our code in `Users::OmniauthCallbacksController.cas()` with the information about the user that authenticated. From that point on we know we have a valid session and can allow the user to perform the activities that they are authorized in our application.
* You can view what information is available via CAS about the authenticated user here: https://fed.princeton.edu/cas/login


## Rails integration
1. Update your Gemfile to include devise and cas
   ```
   # Single sign on
   gem "devise"
   gem "omniauth-cas"
   ```

1. Run the devise generators
   ```
   rails generate devise:install
   rails generate devise User
   ```

1. Add authentication to your `app/controllers/application_controller.rb`
   ```
      protect_from_forgery with: :exception
      before_action :authenticate_user!

      def new_session_path(_scope)
        new_user_session_path
      end
   ```

1. Create a new controller  `app/controllers/users/omniauth_callbacks_controller.rb`

   ```
    class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
      def cas
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_cas(request.env["omniauth.auth"])

        unless @user.nil?
          sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: 'from Princeton Central Authentication '\
                                                    'Service') if is_navigational_format?
        else
          redirect_to root_path
          flash[:notice] = 'You are not authorized to view this material'
        end
      end
    end

   ```

1. Add Omni auth to app/models/user.rb
   ```
    devise :omniauthable

    def self.from_cas(access_token)
      user = User.find_by(provider: access_token.provider, uid: access_token.uid)
      if user.nil?
        # Create the user with some basic information from CAS.
        #
        # Other bits of information that we could use are:
        #
        #   access_token.extra.department (e.g. "Library - Information Technology")
        #   access_token.extra.extra.departmentnumber (e.g. "41006")
        #   access_token.extra.givenname (e.g. "Harriet")
        #   access_token.extra.displayname (e.g. "Harriet Tubman")
        #
        user = User.new
        user.provider = access_token.provider
        user.uid = access_token.uid # this is the netid
        user.email = access_token.extra.mail
        user.save
      end
      user
    end
   ```

1. On the welcome page for your site, allow unauthenticated access. (Without this, we get `undefined method 'session_path'`.)

   ```
   class WelcomeController < ApplicationController
       skip_before_action :authenticate_user!
   ```

3. Update `config/initializers/devise.rb` to tell Devise the location of our CAS server and change they key if needed (`:uid` in our CAS server maps to the user's `netid`)

   ```
   config.omniauth :cas, host: "fed.princeton.edu", url: "https://fed.princeton.edu/cas"
   ...
   config.case_insensitive_keys = [:uid]
   ...
   config.strip_whitespace_keys = [:uid]
   ```

1. Add a login button to one of your pages

   ```
   <%= button_to "Login", user_cas_omniauth_authorize_path %>
   ```

1. Make sure you have a root path in `config/routes.rb`
   ```
   root <your root path>
   ```

1. Add a route for the CAS controller by changing devise_for in `config/routes.rb` to

   ```
   devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

   devise_scope :user do
     get "sign_in", to: "devise/sessions#new", as: :new_user_session
     get "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
   end
   ```

1. Generate a migration to add the CAS fields to a user
   ```
   rails generate migration AddCasToUser provider:string:index uid:string:index
   ```

1. Add Devise helpers to you `spec/rails_helper.rb`

    ```
    # note: require 'devise' after require 'rspec/rails'
    require 'devise'

    ...

    RSpec.configure do |config|

      ...
      config.include Devise::Test::ControllerHelpers, type: :controller
      config.include Devise::Test::IntegrationHelpers, type: :request
      config.include Devise::Test::IntegrationHelpers, type: :system
    end
    ```

1. If you do not already have factory bot installed:

   1. Add factorybot to your Gemfile
      ```
      group :development, :test do
        gem 'factory_bot_rails', require: false
      end
   1. Add a spec/factories directory and include spec/factories/user.rb
      ```
      FactoryBot.define do
        factory :user do
          sequence(:uid) { "uid#{srand}" }
          sequence(:email) { "email-#{srand}@princeton.edu" }
          provider 'cas'
          password 'foobarfoo'
        end
      end
      ```

1. Add Sign_in to tests that are behind the login

   ```
   require 'rails_helper'

    RSpec.describe "Events", type: :request do
      describe "GET /events" do
        ######
        # This is needed since devise will block access unless signed in
        #
        let(:user ) { FactoryBot.create :user }
        before do
          sign_in user
        end
        #
        # end of new code for devise/cas
        #####

        it "works! (now write some real specs)" do
          get events_path
          expect(response).to have_http_status(200)
        end
      end
    end
   ```
