# SAML with an external vendor

## Requesting SAML access for a vendored app from OIT

Whenever you need SAML with an external vendor, you need to register the application with our SAML service. The quickest way to do this is via [Service Now](https://princeton.service-now.com/snap/). 

Go to Request Catalog -> Netid, Accounts and Security, Security

The form requests these fields:

* Service Name (required)
* Technical Contact For Vendor (required)
* Technical Contact Phone Number (required)
* Technical Contact Email (required)
* Service Provider Metadata URL
* Is the Service Provider a member of InCommon?
* Does the service provider support SAML2?

## Understanding the SAML Metadata

When your Service Now request is fulfilled, OIT will send you an XML metadata file that includes several of the fields you provided above, plus some new ones. The most important one is the X509 Certificate:

EntityDescriptor - contains the URL of the vendor application as the entityID
  SPSSODescriptor - outer wrapper field
    KeyDescriptor/KeyInfo/X509Data - inner wrapper fields
      X509 Certificate - the certificate for the SAML Service Provider (see below)
    NameIDFormat
    AssertionConsumerService
  Organization
    OrganizationName
    OrganizationDisplayName
    OrganizationURL
  ContactPerson (technical)
  ContactPerson (support)

The entityID must match exactly, including the presence or absence of a trailing slash - there's a difference between https://mysite.princeton.edu/ and https://mysite.princeton.edu. 

## Setting up SAML access

A SAML connection involves a handshake between two parties:

- the SAML Identity Provider (IdP) - this is the Princeton SSO service
- the SAML Service Provider (SP) - this is the vendor application

At a minimum, the IdP sends a user ID and authentication status for each user. It can also send other fields. OIT must define these fields on the IdP side of the handshake, and you must define them on the SP side.

Most SAML handshakes include basic fields like the user's first name, last name, and email address. The IdP sends these fields and the SP generally adds them to the user's profile within the vendor's application. If you want to use group information from LDAP to control authorization in the vendor's application, you must request the fields as part of the SAML handshake. 

## Configuring security in the SAML handshake

There are four settings on the IdP end that control what kind of security the Princeton Identity Provider expects to get and provide for the authentication exchange:

encryptAssertions
signAssertions
encryptNameIDs
signResponses

Each setting can be either true or false. The settings on the IdP must match the settings in the SP. The SP may define these security settings by default or allow you to configure them. The IdP settings are included in the XML metadata file, in the SPSSODescriptor field. For example, `AuthnRequestsSigned="false" WantAssertionsSigned="false"`

