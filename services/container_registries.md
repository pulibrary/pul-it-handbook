### GitHub Container Registry (GHCR.io)

GitHub Container Registry (GHCR.io) provides a secure, integrated container registry service that works seamlessly with GitHub repositories and Actions.

#### Giving somebody an account

1. Access is automatically granted to members of the GitHub organization/repository
2. For fine-grained permissions, configure repository/package access in the repository settings:
   - Go to the repository → Settings → Actions → General
   - Configure workflow permissions to allow access to packages

#### Setting up your new account

1. **Create a Personal Access Token (PAT):**
   - Go to [GitHub Settings → Developer Settings → Personal Access Tokens](https://github.com/settings/tokens)
   - Create a new token with `read:packages` and `write:packages` scopes
   - Give the token an appropriate name and expiration

2. **Authenticate locally:**

      ```sh
      # Login using your GitHub username and PAT echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
      ```

   3. **Push images:**

      ```sh
      podman tag my-image ghcr.io/organization/repository:tag docker push ghcr.io/organization/repository:tag
      ```

#### Setting up GitHub Actions workflow

   For automated builds and deployments, use the built-in `GITHUB_TOKEN`:

   ```yaml
    name: Build and Push Container
    on: [push]
    jobs:
      build:
        runs-on: ubuntu-latest
        permissions:
          contents: read
          packages: write
        steps:
          - uses: actions/checkout@v4 

          - name: Login to GitHub Container Registry
            uses: docker/login-action@v3
            with:
              registry: ghcr.io
              username: ${{ github.actor }}
              password: ${{ secrets.GITHUB_TOKEN }}

          - name: Build and push
            run: |
              docker build -t ghcr.io/${{ github.repository }}:latest .
              docker push ghcr.io/${{ github.repository }}:latest
```

#### Migration from Quay.io

   When migrating existing images:

   1. Pull the image from Quay.io: `docker pull quay.io/organization/repository:tag`
   2. Retag for GHCR.io: `docker tag quay.io/organization/repository:tag ghcr.io/organization/repository:tag`
   3. Push to GHCR.io: `docker push ghcr.io/organization/repository:tag`
   4. Update deployment configurations to use the new registry URL

#### Security Best Practices

   - Use `GITHUB_TOKEN` in workflows instead of personal access tokens when possible
   - Set appropriate expiration times for PATs
   - Use the principle of least privilege for token scopes
   - Regularly audit and rotate credentials
   - Enable 2FA for all GitHub accounts

### Quay.io

Quay.io is our preferred container registry for RHEL based projects.

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
