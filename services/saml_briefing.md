# SAML 2.0 (Security Assertion Markup Language)

A Comparative Briefing with Findings from research on SAML and OIDC

## What It Is

SAML 2.0 is an XML-based federated identity standard ratified by OASIS in March 2005, building on work developed for enterprise, XML-based web services. As the older of the two dominant federated-authentication standards discussed in this briefing, it reflects the technological priorities and constraints of its era.

## Key Concepts and Terminology

- **SP (Service Provider)** — The application a user is trying to access, which relies on an Identity Provider's assertion rather than authenticating the user directly.
- **IdP (Identity Provider)** — The trusted system that authenticates a user and issues a signed statement of identity to a Service Provider.
- **Assertion** — A signed statement issued by a SAML Identity Provider, certifying that a user has been authenticated.
- **Attribute Mapping** — The process of translating identity attributes or claims held by an Identity Provider into the fields a Service Provider expects to receive.
- **XML** — Extensible Markup Language, the structured, verbose markup format used by SAML assertions.

## Data Format and Trust Model

SAML2 encodes its identity assertions in XML, producing a verbose, signature-heavy payload — a typical signed assertion runs approximately 4 KB once base64-encoded (versus roughly 1.2 KB for an equivalent OIDC JWT). SAML2 builds a direct trust relationship between SP and IdP via exchanged metadata, in contrast to OIDC's reliance on transport-channel (HTTPS) security.

## Strengths and Limitations

**Strengths:**
- Mature, deeply embedded in enterprise identity providers
- Well suited to complex, attribute-based access control
- Long production track record across regulated industries

**Limitations:**
- Verbose XML payloads increase processing overhead
- Comparatively poor fit for mobile and single-page applications
- Configuration is more involved, historically requiring more mandatory fields than an equivalent OIDC setup

SAML2 continues to serve as the backbone of enterprise Single Sign-On (SSO), providing authentication for platforms including Microsoft Entra ID, AWS, Salesforce, Workday, and Atlassian.

## SAML2 Web SSO Flow (SP-Initiated)

1. The user attempts to access a protected resource at the Service Provider.
2. The SP, recognizing the user is unauthenticated, redirects the browser to the Identity Provider with an authentication request.
3. The user authenticates directly with the IdP.
4. The IdP returns a signed SAML assertion to the browser, which is forwarded (typically via an HTTP POST) to the SP.
5. The SP validates the assertion's signature and conditions (audience, expiry) before granting access.

Unlike OIDC's back-channel token exchange, SAML2's assertion is carried entirely through front-channel browser redirects.

## Applied Context

Duo Single Sign-On can act as either a SAML 2.0 identity provider or an OpenID Connect provider. At enterprise scale, supporting both protocols is standard practice for a mature identity ecosystem — for example, Okta alone maintains more than 8,000 pre-built application integrations, each federating via either SAML 2.0 or OIDC depending on customer configuration.

## Princeton's SAML Path via Entra ID

Microsoft Entra ID supports SAML as one of two integration paths:

| Integration Path | OIT Involvement Required | Configuration Method |
|---|---|---|
| SAML 2.0 | Yes | Submission of a request/ticket to the OIT service desk for provider-side configuration |

### The SAML ("Enterprise Applications") Path — RDSS Practice

- Only applications registered as "Enterprise Applications" within the Entra ID console can utilize SAML properties — essential for any integration involving Grouper or the Mediaflux/Entra integration.
- OIT is responsible for creating these Enterprise Application registrations on behalf of the team; the team cannot self-provision them.
- When an existing SAML-authorized application requires migration to Entra ID/OIDC, team practice is to explicitly request assistance from Francis and the Operations group. A completed example: the Pulelemetry Staging application, successfully transferred from SAML to Entra ID/OIDC.
- Example SAML-based (non-OIDC) application: Palo Alto (PAN-OS), which relies on the Mail Nickname (`User.mailnickname`) attribute as its identity key rather than email or User Principal Name.

## Identifiers and Client Secret Rotation

- Every application registration is associated with a consistent Directory/Tenant ID (shared across all Princeton applications) and a unique Application ID.
- A Client Secret is required per application and must be regenerated at minimum every six months. Each secret has both a *secret ID* and a *secret value*.
- Automated (TSR) notifications for upcoming secret expiration are not considered reliable; current best practice is manual regeneration, documented explicitly as a dedicated engineering spike.

## Case Study: The EZproxy Migration to Entra ID

Findings based on an interview with Vickie, a member of the Library's Operations team, regarding the migration of EZproxy — the Library's off-campus electronic resource access proxy — to Entra ID-based authentication. (Note: this project pertains specifically to EZproxy, not the persistent-identifier service EZID.)

### Background and Rationale

- EZproxy is locally hosted at Princeton and heavily used; service interruptions are reported almost immediately.
- The Entra ID migration was undertaken alongside a broader infrastructure initiative to fully automate the EZproxy server via Ansible, replacing a previously manual, SSH-based configuration process.
- Once server automation was in place, incorporating Entra ID authentication parameters (tenant ID, object ID) into the Ansible configuration was comparatively straightforward.
- The prior authentication method relied on CAS/SAML-based login; the migration required a brief planned production outage.

### Protocol Selection

Notably, both EZproxy and an earlier integration (ORCID) were ultimately implemented using the **OIDC** self-registration path, specifically to avoid the additional coordination overhead of an OIT-mediated SAML setup.

### Access Management via Grouper

User access provisioning relies on Grouper, an OIT-managed tool organizing university affiliates into role-based groups (staff, faculty, students). Accurately mapping the "Electronic Resources Users" group from Grouper to Entra ID was crucial. Several edge cases arose post-migration, particularly for affiliates with non-standard institutional relationships (e.g., Princeton Plasma Physics Laboratory personnel) — ensuring continuity of access for all previously eligible users was one of the most error-prone aspects of the migration.

### Multi-Factor Authentication Discrepancy

Entra ID's default MFA mechanism is Microsoft Authenticator, not Princeton's standard MFA application, Duo. This discrepancy caused user confusion immediately after migration. OIT maintains documentation for reconfiguring Entra ID's default MFA provider to Duo.

### Documentation Status

At the time of the interview, it was unclear whether the Princeton University Library (PUL) Handbook or the team's internal Operations Handbook documented the Entra ID configuration procedures.

## Grouper Integration and Directionality

Entra ID supports propagating IAM metadata, and specific IAM Groups can be identified via the "Access All Groups" interface. Grouper remains the authoritative source of truth for group membership; policy propagation flows in one direction only — from Grouper into Entra ID — and is never reflected back.

## Open Questions

- **No established pattern for Group support in SAML:** The team has a working, self-service pattern for enabling group-based access within OIDC integrations (adding the Grouper Group as an application owner), but no equivalent pattern exists for SAML ("Enterprise Application") integrations. This creates a gap for any future application requiring both SAML and group-based access.
- **Planned engagement with the IAM group:** The team intends to collaborate directly with Princeton's Identity and Access Management (IAM) group to obtain a recommended approach for enabling Groups across both OIDC and SAML integrations. This engagement is underway and considered a priority.

## Relevant Action Items

- Obtain any existing PUL Handbook or Operations Handbook documentation on the Entra ID integration process.
- Obtain written clarification distinguishing the OIDC self-service path from the SAML/OIT-ticket path.
- Confirm whether OIT continues to use a formal request form for SAML integrations or has moved to a ticket-only process.
- Schedule a working session with the institutional IAM group to determine a recommended approach for enabling group-based access in both OIDC and SAML integrations.
- Clarify and document decision criteria for handling inactive `libvi[NetID]` accounts (expiration vs. explicit OIT-disable request).

## References

- OASIS. (2005). *Security Assertion Markup Language (SAML) V2.0*. OASIS Open. https://www.oasis-open.org/standard/saml/
- OASIS. (2008). *Security Assertion Markup Language (SAML) V2.0 technical overview* [OASIS Committee Draft]. https://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html
- Princeton University Library. (n.d.). *CAS/SAML configuration reference*. PUL IT Handbook. https://github.com/pulibrary/pul-it-handbook/blob/main/services/cas.md
- RDSS Team. (2026). *Internal team meeting notes on Entra ID and OIDC/SAML application registration practices* [Unpublished internal documentation]. Princeton University Library.
- StrongDM. (2025). *The difference between SAML vs OIDC*. https://www.strongdm.com/blog/oidc-vs-saml
- SSOJet. (2026). *Okta SAML vs OIDC for SaaS vendors: What enterprise customers expect*. https://ssojet.com/blog/okta-saml-vs-oidc-saas-vendors
- Software Secured. (2026). *OpenID Connect vs SAML v2.0 vs OAuth 2.0*. https://www.softwaresecured.com/post/federated-identities-openid-vs-saml-vs-oauth