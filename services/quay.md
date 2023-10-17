### Quay.io

Quay.io is our preferred container registry.

#### Giving somebody an account

1. Go to the [pulibrary teams and memberships page](https://quay.io/organization/pulibrary?tab=teams) in quay.
2. Click Owners
3. Type the person's email address, then press Enter

#### Setting up your new account

1. Create a Red Hat account, if you don't already have one (you can do so at the [quay.io login page](https://quay.io/repository/).
2. Click on the invite link in your email. This will take you to the pulibrary page in quay.
3. Click your username (in the top righthand corner of the screen)
4. Select "Account Settings"
5. Add a password (this is not the same as your Red Hat account password)
6. Click the "Generate encrypted password" link.
7. You can now `docker login` or `podman login` using your Red Hat username and the encrypted password.
