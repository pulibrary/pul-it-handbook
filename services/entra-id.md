# Entra ID

Microsoft Entra ID is Microsoft’s identity platform for OAuth 2.0 and OpenID Connect authentication. These instructions describe how to allow a Ruby application to authenticate a user with Entra ID via the `omniauth-entra-id` gems. The omniauth-entra-id gem uses the OmniAuth strategy name entra_id, not azure_oauth2.

## General workflow

When integrating Entra ID via these instructions, the general workflow of the application is more or less as follows:

There is a button in the app to authenticate via Microsoft Entra ID.
When a user clicks this button, the app begins the OmniAuth request phase and redirects the user to Microsoft’s login endpoint. The `omniauth-entra-id` gem defaults to https://login.microsoftonline.com and uses the `openid profile email` scope unless configured otherwise.

  - The user authenticates with Princeton/Microsoft credentials and any required MFA.

  - Upon authentication, Microsoft redirects back to the Rails application at the OmniAuth callback endpoint, for example:

`https://pulrubyapp.princeton.edu/users/auth/entra_id/callback`

  - From that point on we know we have a valid authenticated identity and can allow the user to perform the activities that they are authorized to perform in the application.
  - The `omniauth-entra-id` auth hash includes values such as `provider`, `uid`, `info.email`, `info.name`, `info.first_name`, `info.last_name`, and `extra.raw_info`. 
