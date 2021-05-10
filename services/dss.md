# DSS Blackligtht Application

## Database Table Size

Sometimes blacklight brings unwelcome guests. Guest users and searches to be
exact. If the database becomes too full the ```searches``` and ```users```
tables need to be purged of the anonymous users and blank saved search values
that each unique session started in blacklight generates. If the daily delete
guest users and delete old searches rake tasks fail for an extended period of
time you need to manually do this the by running the following commands in the 
DB console:

```
delete from searches where user_id is NULL and updated_at <=
'YYYY-MM-DD';
```
```
delete from users where guest = 1 and provider is NULL and created_at <=
'YYYY-MM-DD';
```

where `YYYY-MM-DD` is yesterday. 
