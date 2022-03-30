If you are trying to deploy a private repo via capistrano, and get the following errors:

```
Load key "/home/deploy/.ssh/id_rsa": invalid format\r
git@github.com: Permission denied (publickey).\r
fatal: Could not read from remote repository.
```

Try running `ssh-add ~/.ssh/id_rsa`
