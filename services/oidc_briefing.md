# OpenID Connect (OIDC)

OpenID Connect and SAML 2.0: A Comparative Briefing with Findings from the Princeton EZproxy Entra ID Migration and RDSS Team Practice

## What It Is

OpenID Connect is a lightweight, JSON-based identity layer built on top of the OAuth 2.0 authorization framework. OpenID Connect Core 1.0 was published in February 2014 by the OpenID Foundation, considerably later than SAML2, reflecting a different set of technological priorities: mobile, API-driven, and self-service-friendly authentication.

## Key Concepts and Terminology

- **RP (Relying Party)** — OIDC's term for the application relying on the Identity Provider's authentication (equivalent to a SAML Service Provider).
- **ID Token** — A signed JSON Web Token (JWT) issued by an OIDC provider, containing claims that identify the authenticated user.
- **Access Token** — A credential issued by an OAuth 2.0 or OIDC authorization server granting the bearer access to a protected resource or API, distinct from an ID token, which conveys identity rather than resource access.
- **Claim** — A single piece of identity information (e.g., email address, name) carried inside an OIDC ID token.
- **Scope** — A parameter in an OIDC/OAuth request specifying what access or identity information is being requested (e.g., `openid profile email`).
- **Authorization Code** — A short-lived credential returned midway through the OIDC login flow, exchanged by the client application for an ID token and access token.
- **JWT** — JSON Web Token, the compact, signed token format used to carry identity claims in OIDC.

## Data Format and Trust Model

OIDC encodes its ID token as a JWT, a lightweight artifact — on the order of 1.2 KB for an equivalent identity claim (versus roughly 4 KB for a comparable SAML2 assertion). Rather than establishing trust through exchanged metadata (as SAML2 does), OIDC relies on the security of the transport channel (HTTPS) between the parties.

## Strengths and Limitations

**Strengths:**
- Lightweight JSON/JWT-based tokens
- Native fit for REST APIs, mobile applications, and single-page applications (SPAs)
- Simpler, self-service configuration

**Limitations:**
- Comparatively newer, with a shorter track record in some high-assurance enterprise contexts
- Depends conceptually on OAuth 2.0 as an underlying framework

OIDC has emerged as the widely adopted standard for consumer and mobile identity, powering the majority of "Sign in with Google"-style authentication flows.

## OIDC Authorization Code Flow

1. The user initiates login at the client application (the Relying Party).
2. The client redirects the user to the OpenID Provider's authorization endpoint.
3. The user authenticates and grants consent.
4. The OpenID Provider redirects back to the client with a short-lived authorization code.
5. The client exchanges that code for an ID token and access token directly with the provider, over a secure server-to-server channel — not through the user's browser.

This back-channel token exchange (step 5) is a key distinction from SAML2, whose assertion is carried entirely through front-channel browser redirects.

## Applied Context

Duo Single Sign-On can act as either a SAML 2.0 identity provider or an OpenID Connect provider. At enterprise scale, supporting both protocols — rather than exclusively choosing one — is standard practice for a mature identity ecosystem (e.g., Okta maintains more than 8,000 pre-built application integrations spanning both).

## Princeton's OIDC Path via Entra ID

Microsoft Entra ID supports OIDC as one of two integration paths:

| Integration Path | OIT Involvement Required | Configuration Method |
|---|---|---|
| OpenID Connect (OIDC) | No | Self-service application registration within the Entra ID portal |

Both EZproxy and an earlier integration (ORCID) were implemented using the OIDC self-registration path, avoiding the additional coordination overhead of an OIT-mediated SAML setup. The ORCID integration is regarded internally as a reliable implementation template for future self-service registrations.

### The OIDC ("App Registrations") Path — RDSS Practice

- Registering a new OIDC application requires OIT-issued credentials; otherwise the registration attempt is rejected.
- Application type must be set to **Web**; the redirect URI is provided by the RDSS developers responsible for the application.
- Before registering a new application, team practice is to first check for an existing application already configured for OIDC/Ruby Gem integration, referring to the Open Athens Ruby OpenID Connect example and the `omniauth-entra-id` gem for guidance.
- **Limitation:** Applications registered through the OIDC ("App registrations") path cannot consume Groups from the Princeton Grouper service. Workaround: explicitly add the relevant Grouper Group as an *owner* of the application, rather than relying on group-based claims within the token itself.

## Identifiers and Client Secret Rotation

- Every application registration has a consistent Directory/Tenant ID (shared across all Princeton applications) and a unique Application (Client) ID.
- A Client Secret is required per application and must be regenerated at minimum every six months. Each secret has both a *secret ID* and a *secret value* — configuration steps must reference the correct one.
- Automated (TSR) notifications for upcoming secret expiration are not considered reliable; current best practice is manual regeneration, documented explicitly as a dedicated engineering spike.

## Identity Field Variability

Entra ID returns different identity fields depending on the service provider (User Principal Name, email address, Mail Nickname), and determining the correct one for a given integration can require trial and error. NetID formatting is also inconsistent across applications (bare NetID vs. `NetID@princeton.edu`). During first authentication to a newly integrated application, MFA may be re-prompted even if already completed elsewhere in the session; subsequent authentications are usually unaffected.

## Ruby Application Integration Reference (RDSS Internal Guide)

Documents how RDSS-built Ruby applications authenticate via Entra ID using the `omniauth-entra-id` gem (guide authored by Carolyn, 2026).

### Authentication Workflow

The gem registers under the OmniAuth strategy name `entra_id` (not `Azure_oauth2`). Flow:

1. User clicks sign-in, triggering the OmniAuth request phase.
2. Redirect to Microsoft's login endpoint (defaults to `https://login.microsoftonline.com`) with the `openid profile email` scope.
3. User authenticates with Princeton/Microsoft credentials (and any required MFA).
4. Microsoft redirects back to the Rails application's OmniAuth callback endpoint, e.g.:
   `https://pulrubyapp.princeton.edu/users/auth/entra_id/callback`

The resulting auth hash includes `provider`, `uid`, `info.email`, `info.name`, `info.first_name`, `info.last_name`, and `extra.raw_info`.

### App Registration Steps

1. Create a new app registration in the Microsoft Entra admin center. For development environments using `http://localhost:3000`, select "Multiple Entra ID tenants."
2. Prefer separate app registrations for development, staging, and production; Microsoft recommends not exposing development redirect URIs within production app registrations.
3. Add the appropriate redirect URI for each environment — Entra ID only redirects to, and issues tokens for, explicitly registered URIs; a mismatch produces an `AADSTS50011` error.
4. Register the redirect URI under the "Web" platform type (appropriate for a traditional server-rendered Rails application).
5. Create a client secret (the secret value is visible only once, at creation).
6. Record the following values (client-secret value stored securely, e.g., in a password manager):
   ```
   ENTRA_CLIENT_ID=<application-client-id>
   ENTRA_CLIENT_SECRET=<client-secret-value>
   ENTRA_TENANT_ID=<Princeton's global tenant ID>
   ```
7. Add the rest of the development team as Owners of the application registration (unless it is a personal development-only key).
8. Optionally configure additional attributes if needed; group-based claims were not found to function reliably in this configuration (consistent with the Grouper limitation noted above).

### Ruby Integration

Add the `omniauth-entra-id` gem to the Gemfile and run `bundle install`. The unique Princeton identifier (NetID) can be derived from the returned `raw_info` payload:

```ruby
# full email: abc123@princeton.edu
access_token.extra.raw_info.unique_name
# NetID only: abc123
access_token.extra.raw_info.unique_name.split('@princeton.edu').first
```

### Framework-Specific Notes

The guide provides a comprehensive integration path for Hanami applications (configuration, OmniAuth middleware registration, environment variables, callback routing, and an example authentication action modeled after the team's existing CAS integration pattern). Equivalent Rails-specific integration guidance is not yet written and is marked "TBD" as of this briefing.

## Open Questions

- **Entra ID requirements for TigerData:** The OIDC path that has reliably worked for ORCID@Princeton may not be compatible with TigerData out of the box, but the specific gap and requirements have not been fully scoped.
- **Group support:** A working, self-service pattern exists for enabling group-based access within OIDC integrations (adding the Grouper Group as an application owner), but no equivalent pattern exists yet for SAML. The team plans to engage Princeton's IAM group to find a recommended approach across both protocols.

## Relevant Action Items

- Obtain written clarification distinguishing the OIDC self-service path from the SAML/OIT-ticket path.
- Adopt the ORCID OIDC registration as a reference template for future self-service integrations.
- Scope the specific requirements for implementing Entra ID authentication with TigerData.
- Document the manual client-secret regeneration process as a formal, repeatable runbook.
- Establish a standard practice for identifying the correct identity-claim field (UPN vs. email vs. Mail Nickname) at the start of each new integration.
- Complete Rails-specific integration guidance in Carolyn's internal Ruby/Entra ID reference.

## References

- Hardt, D. (Ed.). (2012). *The OAuth 2.0 authorization framework* (RFC 6749). Internet Engineering Task Force. https://datatracker.ietf.org/doc/html/rfc6749
- OpenID Foundation. (2014). *OpenID Connect Core 1.0 incorporating errata set 1*. https://openid.net/specs/openid-connect-core-1_0.html
- OpenAthens. (n.d.). *Ruby OpenID Connect example*. https://docs.openathens.net/providers/ruby-openid-connect-example
- Pond, A. (n.d.). *omniauth-entra-id* [Computer software]. GitHub. https://github.com/pond/omniauth-entra-id
- Carolyn. (2026). *Entra ID integration guide for Ruby applications* [Internal documentation]. Princeton University Library, Research Data and Scholarship Services.
- Cisco Duo. (2026). *How to use Duo Single Sign-On (SSO)*. https://duo.com/docs/sso
- SSOJet. (2026). *Okta SAML vs OIDC for SaaS vendors: What enterprise customers expect*. https://ssojet.com/blog/okta-saml-vs-oidc-saas-vendors
- Software Secured. (2026). *OpenID Connect vs SAML v2.0 vs OAuth 2.0*. https://www.softwaresecured.com/post/federated-identities-openid-vs-saml-vs-oauth