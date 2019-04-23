# Cas Rails Integration

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

1. Add authentication to your app/controllers/application_controller.rb
   ```
      protect_from_forgery with: :exception
      before_action :authenticate_user!
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
      User.where(provider: access_token.provider, uid: access_token.uid).first
    end
   ```

1. Add a login button to one of your pages

   ```
   <%= button_to "Login", user_cas_omniauth_callback_path %>
   ```

1. Change the devise key if needed in config/inititalizers/deviser.rb

   ```
   config.case_insensitive_keys = [:uid]
   ...
   config.strip_whitespace_keys = [:uid]
   ```

1. Make sure you have a root path in config/routs.rb
   ```
   root <your root path>
   ```

1. Add a route for the cas controller by changing devise_for in config/routes.rb to

   ```
   devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
   ```

1. Generate a migration to add the cas fields to a user
   ```
   rails generate migration AddCasToUser provider:string:index uid:string:index
   ```
1.  add Devise helpers to you spec/rails_helper.rb 

    ```
    # note: require 'devise' after require 'rspec/rails'
    require 'devise'

    ...

    RSpec.configure do |config|

      ...
      config.include Devise::Test::ControllerHelpers, type: :controller
      config.include Devise::Test::IntegrationHelpers, type: :request
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
