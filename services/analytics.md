# Analytics

## Google Tag Manager

[Google Tag Manager](https://marketingplatform.google.com/about/tag-manager/) is a front-end code injection tool. We add the google tag manager code snippets to each of our sites and use the google tag manager UI to define the code we want injected. We're using it to inject analytics code. You can access the UI at (TODO: add link).

This workflow empowers our AUX team to implement analytics updates to our sites without setting up and submitting pull requests to each code base.

Google Tag Manager is not a tracking tool.


## Umami

Umami is a simple, fast, privacy-focused alternative to Google Analytics.

The UI for viewing the data is at https://analytics.lib.princeton.edu.

To log in, find the credentials in Lastpass under "Umami".

Umami runs on the [nomad Infrastructure](https://github.com/pulibrary/princeton_ansible/tree/main/nomad). 
