# Migrate Data from Fly.io to DigitalOcean

We wrote a **_generic_ guide**
on backing-up data from Fly.io:
[learn-devops/postgres/backup-fly-postgres.md](https://github.com/dwyl/learn-devops/blob/main/postgres/backup-fly-postgres.md)

This migration guide follows that
but is _specific_ to the `Hits` project/app.

> **Before starting**: ensure you have the latest version
> of the `Fly CLI`; `brew install flyctl` or `brew reinstall flyctl`.
> Test it's working with `fly auth whoami`

Once authenticated, run:

```sh
fly proxy 5432 -a hits-db
```

In a second terminal window run:

```sh
flyctl ssh console -a hits -C "printenv DATABASE_URL"
```

Output example:

```sh
postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bfetc@hits-db.internal:5432/hits?sslmode=disable
```

Extract the password from the URL
then export it to the terminal session:

```sh
export PGPASSWORD="baf3d9f0bdf155bfetc"
```

Now run the command:

```sh
pg_dump -h localhost -U hits_e2k5m6j4k46d0v7p -d hits --verbose > backup.sql
```

Kept getting the following error:
```sh
pg_dump: error: connection to server at "localhost" (::1), port 5432 failed: Connection refused
        Is the server running on that host and accepting TCP/IP connections?
connection to server at "localhost" (127.0.0.1), port 5432 failed: server closed the connection unexpectedly
        This probably means the server terminated abnormally
        before or while processing the request.
```

Read: https://community.fly.io/t/backup-and-restore-postgresql/11320/7

Updated the command to:

```sh
pg_dump -h localhost -U hits_e2k5m6j4k46d0v7p -d hits-db --verbose > backup.sql
```

Tried:

```sh
pg_dump -p 5432 -h localhost -U postgres -W -c -f flyback.bak -d hits --verbose
```

Didn't expect it to work with the `user` set to `postgres` ...

```sh
psql -p 5432 -h localhost -U hits_e2k5m6j4k46d0v7p
```

This worked:

```sh
psql postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bf877a057f39529005@localhost:5432/hits
```

Followed by:

```md
\dt
                     List of relations
 Schema |       Name        | Type  |         Owner
--------+-------------------+-------+-----------------------
 public | hits              | table | hits_e2k5m6j4k46d0v7p
 public | repositories      | table | hits_e2k5m6j4k46d0v7p
 public | schema_migrations | table | hits_e2k5m6j4k46d0v7p
 public | useragents        | table | hits_e2k5m6j4k46d0v7p
 public | users             | table | hits_e2k5m6j4k46d0v7p
(5 rows)
```

So let's try:

```sh
pg_dump postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bf877a057f39529005@localhost:5432/hits -f flyback.bak -d hits --verbose
```

It _appears_ to be working, but then **times-out**:

```sh
pg_dump: creating TABLE "public.users"
pg_dump: creating SEQUENCE "public.users_id_seq"
pg_dump: creating SEQUENCE OWNED BY "public.users_id_seq"
pg_dump: creating DEFAULT "public.hits id"
pg_dump: creating DEFAULT "public.repositories id"
pg_dump: creating DEFAULT "public.useragents id"
pg_dump: creating DEFAULT "public.users id"
pg_dump: processing data for table "public.hits"
pg_dump: dumping contents of table "public.hits"
pg_dump: error: Dumping the contents of table "hits" failed: PQgetCopyData() failed.
pg_dump: error: Error message from server: server closed the connection unexpectedly
	This probably means the server terminated abnormally
	before or while processing the request.
pg_dump: error: The command was: COPY public.hits (id, repo_id, useragent_id, inserted_at, updated_at) TO stdout;
```

Trying: 
https://stackoverflow.com/questions/9235727/postgres-pg-dump-times-out

```sh
pg_dump postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bf877a057f39529005@localhost:5432/hits -f flyback.bak -d hits --verbose PGOPTIONS="-c statement_timeout=0" 
```

Got the following error:

```sh
pg_dump: error: too many command-line arguments (first is "postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bf877a057f39529005@localhost:5432/hits")
Try "pg_dump --help" for more information.
```

Reading: 
https://serverfault.com/questions/1081642/postgresql-13-speed-up-pg-dump-to-5-minutes-instead-of-70-minutes


```sh
pg_dump postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bf877a057f39529005@localhost:5432/hits -f flyback.bak -d hits --verbose -j 8
```

Now I keep getting the error:

```sh
pg_dump: error: too many command-line arguments (first is "postgres://hits_e2k5m6j4k46d0v7p:baf3d9f0bdf155bf877a057f39529005@localhost:5432/hits")
pg_dump: hint: Try "pg_dump --help" for more information.
```

Running:

```sh
SELECT count(*) AS exact_count FROM hits;
```

We see:

<img src="https://github.com/user-attachments/assets/bfd8134b-6ecb-4daa-8326-3e2559091cfc" />

# 30,300,632

Thirty Million Rows. 🤯

The query takes 244 seconds (4 minutes) to run! ⏳

Read:
https://stackoverflow.com/questions/55018986/postgresql-select-count-query-takes-long-time

