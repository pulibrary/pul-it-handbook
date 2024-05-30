# SMTP Mail Server

We have an smtp server at `lib-ponyexpr-prod.princeton.edu` which can be used to send mail

Instructions to [Add your VM are in the postfix role](https://github.com/pulibrary/princeton_ansible/tree/main/roles/postfix)

For a ruby app you'll need the following configuration in `config/environments/production.rb`:

```
  # config.action_mailer.delivery_method = :sendmail
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address:              'lib-ponyexpr.princeton.edu'
  }

  config.action_mailer.default_options = {
    from: 'no-reply@princeton.edu'
  }
```
