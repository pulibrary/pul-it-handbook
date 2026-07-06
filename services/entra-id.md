# Entra ID

Microsoft Entra ID is Microsoft’s identity platform for OAuth 2.0 and OpenID Connect authentication. These instructions describe how to allow a Ruby application to authenticate a user with Entra ID via the `omniauth-entra-id` gems. The omniauth-entra-id gem uses the OmniAuth strategy name entra_id, not azure_oauth2.

## General workflow

When integrating Entra ID via these instructions, the general workflow of the application is more or less as follows:

There is a button in the app to authenticate via Microsoft Entra ID.
When a user clicks this button, the app begins the OmniAuth request phase and redirects the user to Microsoft’s login endpoint. The `omniauth-entra-id` gem defaults to <https://login.microsoftonline.com> and uses the `openid profile email` scope unless configured otherwise.

- The user authenticates with Princeton/Microsoft credentials and any required MFA.

- Upon authentication, Microsoft redirects back to the Rails application at the OmniAuth callback endpoint, for example:

`https://pulrubyapp.princeton.edu/users/auth/entra_id/callback`

- From that point on we know we have a valid authenticated identity and can allow the user to perform the activities that they are authorized to perform in the application.
- The `omniauth-entra-id` auth hash includes values such as `provider`, `uid`, `info.email`, `info.name`, `info.first_name`, `info.last_name`, and `extra.raw_info`.

## Entra-ID App Registration

Before updating the Ruby application, create an application registration in [Microsoft Entra ID.](https://entra.microsoft.com/#home)

1. In Microsoft Entra admin center, create a new app registration for the Ruby application.
    <img width="1742" height="1008" alt="Screenshot 2026-07-02 at 2 15 23 PM" src="https://github.com/user-attachments/assets/ee31f002-0935-4cf7-a24d-58185e686ce9" />

    For the development environment make certain to select `Multiple Entra ID tenants` since we will be using `http://localhost:3000`

1. Prefer separate app registrations for development, staging, and production. Microsoft recommends not exposing unnecessary development redirect URIs in production app registrations.

1. Add redirect URIs for each environment. Microsoft Entra only redirects users and sends tokens to redirect URIs that have been added to the app registration. If the redirect URI in the login request does not match the app registration, Entra returns an error such as AADSTS50011.

   Example redirect URIs:

   <http://localhost:3000/users/auth/entra_id/callback>

   <https://your-staging-app.princeton.edu/users/auth/entra_id/callback>

   <https://your-production-app.princeton.edu/users/auth/entra_id/callback>

   
1. Add the redirect URI under the Web platform type for a traditional server-rendered Rails application. Microsoft lists Ruby server-side web applications under the Web redirect URI configuration.

   <img width="1066" height="688" alt="Screenshot 2026-07-02 at 2 18 38 PM" src="https://github.com/user-attachments/assets/cfcf6a91-ea5d-4964-8409-1f1bb0420470" />
   
1. Create a client secret for the app registration.
   <img width="1446" height="705" alt="Screenshot 2026-07-06 at 10 40 15 AM" src="https://github.com/user-attachments/assets/5d4426b8-7e57-4dad-adba-95c9d35e3a72" />


1. Save the following values for the Rails application in last pass You will only see the client-secret-value once:

   ENTRA_CLIENT_ID=<application-client-id>
   ENTRA_CLIENT_SECRET=<client-secret-value> # created from `client credentials` in Step. 5
   ENTRA_TENANT_ID=2ff60116-7431-425d-b5af-077d7791bda4 # this is the global PUL ID

   **Note**: for development you should save the information, but as you will be the only user it does not need to be shared

1. Add the rest of your team to the Owners of the application (unless this is a devlopemtn key)
   <img width="1458" height="909" alt="Screenshot 2026-07-02 at 2 22 58 PM" src="https://github.com/user-attachments/assets/cfc41c32-ad63-4dad-ad92-c4fd1d8810fe" />

1. Add attributes you need to have access to.  (In theory you can add groups, but that does not seem to be working)
   This is optional, you could also just utilize the information from info.  That said no uid  like acb123 is present in the infor and the email is your alias email. 
   <img width="1461" height="837" alt="Screenshot 2026-07-06 at 10 15 09 AM" src="https://github.com/user-attachments/assets/dcfd19fe-f5a2-4f50-ab24-ceaf2f3aa311" />


## Rubyapp Integration

1. Update your Gemfile to include Entra ID:

   ```
    # Single sign on
    gem "omniauth-entra-id"
   ```

1. Install the gems:

    bundle install

1. Information from entra will be returned in the request
   ```
   access_token.extra.raw_info.<key your configured>
   ```
1. The UID can be found by pulling the unique name
   ```
   # full email abc123@princeton.edu
   access_token.extra.raw_info.unique_name

   # only uid abc123
   access_token.extra.raw_info.unique_name.split('@princeton.edu').first
   ```

### Hanami
1. Add a setting to the app/settings.rb
   ```
   setting :entra_client_id, default: '', constructor: Types::String
   setting :entra_client_secret, default: '', constructor: Types::String
   ```
1. Add configuration to app/application.rb
   ```
   require 'omniauth-entra-id'

   ...
   # inside class App < Hanami::App
     config.middleware.use OmniAuth::Builder do
        provider :entra_id, client_id: Hanami.app.settings.entra_client_id, client_secret: Hanami.app.settings.entra_client_secret
     end
   ...
   ```
1. Export the secrets to your environment
   export ENTRA_CLIENT_SECRET=<client-secret-value>
   export ENTRA_CLIENT_ID=<application-client-id>

1. Add an additional route for the call back.  Note the URL will be `/auth/entra_id/callback` as specified by the gem
   In config routes add (the to can change to be any location you wish the entra callback to be)
   ```
   get "/auth/entra_id/callback", to: "auth.entra"
   ```
1. Add an action to handle the callback similar to CAS
   **Example code below does not handle errors and assumed the method from_entra_id parse the authorization hash appropriately**
   ```
   module OrcidPrinceton
     module Actions
       module Auth
         class Entra < OrcidPrinceton::Action
           include Deps['repos.user_repo']

           def handle(request, response)
             auth_hash = request.env['omniauth.auth']
             user = user_repo.from_entra_id(auth_hash)
   
             warden_session(request).set_user user.uid
             requested_path = request.session[:login_redirect_url]
             response.flash[:notice] = 'You were successfully authenticated'
             response.redirect_to requested_path || routes.path(:root)
           end
         end
       end
     end
   end
   ```
1. Restart you hanami server
### Rails
   TBD
1. Configure omniauth
    # Hanami
