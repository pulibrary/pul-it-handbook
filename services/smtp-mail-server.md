# SMTP Mail Server

We have an smtp server at `lib-ponyexpr.princeton.edu` which can be used to send mail to princeton email addresses. If you need to send mail to other email addresses, the procedures are not clear; talk to operations to figure this out.

You'll need the box using this mail server added to an allow list. To do so create a SN@P ticket or send a message to lsupport.

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
