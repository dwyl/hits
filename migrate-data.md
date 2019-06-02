# Migrate Hit Data from Filesystem to PostgreSQL

The Node.js MVP saves data to the filesystem
because that was the _simplest_ way
of storing data without having to manage a database.
See: [hits-nodejs/lib/db_filesystem.js#L26-L68](https://github.com/dwyl/hits-nodejs/blob/d896b0c1aae5f99054be67726c6186b4ff662cd3/lib/db_filesystem.js#L26-L68)
https://github.com/dwyl/hits/issues/81

+ [x] Log-in to the Linode instance and inspect how many directories have been created
  (_this is the number of people - GitHub usernames - using the hits badge_)

```sh
ssh root@178.79.141.232
```

+ [x] Count the number of log files in the `/logs` directory:
```sh
ls | wc -l
787
```

+ [x] zip the data on Linode instance to get it off the instance -
because I will be running the Elixir script on my `localhost`.
https://unix.stackexchange.com/questions/93139/zip-an-entire-folder-using-gzip

```sh
cd hits
tar -zcvf data.tar.gz logs/
```

+ [x] download the data archive to `localhost`

https://stackoverflow.com/questions/9427553/how-to-download-a-file-from-server-using-ssh

```sh
scp root@178.79.141.232:hits/logs.tar.gz ./logs.tar.gz
```

+ [x] unzip data on `localhost`

```sh
tar -zxvf logs.tar.gz
```

+ [ ] write the script
  + [ ] insert data into `hits_dev` PostgreSQL on `localhost`
+ [ ] run the script
+ [ ] export the data from `hits_dev` PostgreSQL on `localhost`
+ [ ] load the data on the remote server
