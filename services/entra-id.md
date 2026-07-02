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
2. Prefer separate app registrations for development, staging, and production. Microsoft recommends not exposing unnecessary development redirect URIs in production app registrations.
3. Add redirect URIs for each environment. Microsoft Entra only redirects users and sends tokens to redirect URIs that have been added to the app registration. If the redirect URI in the login request does not match the app registration, Entra returns an error such as AADSTS50011.

   Example redirect URIs:

   <http://localhost:3000/users/auth/entra_id/callback>

   <https://your-staging-app.princeton.edu/users/auth/entra_id/callback>

   <https://your-production-app.princeton.edu/users/auth/entra_id/callback>

4. Add the redirect URI under the Web platform type for a traditional server-rendered Rails application. Microsoft lists Ruby server-side web applications under the Web redirect URI configuration.
5. Create a client secret for the app registration.

   6 Save the following values for the Rails application:

   ENTRA_CLIENT_ID=<application-client-id>
   ENTRA_CLIENT_SECRET=<client-secret-value>
   ENTRA_TENANT_ID=<directory-tenant-id>

## Ruby Integration

Update your Gemfile to include Entra ID:

    # Single sign on
    gem "omniauth-entra-id"

Install the gems:

    bundle install
