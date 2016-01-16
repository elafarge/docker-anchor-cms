# Docker: Anchor CMS

A docker container (actually, there's two docker containers in the final app.
but one of them is just the stock MySQL one) all set to run Anchor CMS and
create a containerized personal website or blog in minutes.

### Global architecture

#### Why MySQL ?

Well, it would have been great to use `postgres` instead (at least just for its
awesome CLI client), acknowledged. But so far, Anchors CMS hasn't been
supporting `postgres`, that's why we preferred to stick to `MySQL/MariaDB`.
Keep in mind that everytime you wish to access your database, you can spin up a
`PHPMyAdmin` container and connect to your DB container in seconds (this one
does the trick for instance: [https://github.com/corbinu/docker-phpmyadmin](https://github.com/corbinu/docker-phpmyadmin).
Otherwise the MySQL CLI client might not be as cool as `postgres`' but it also
does a decent job, especially if you haven't used `postgres` before ;-)

## Requirements

The requirements are rather simple: you'll just need a Linux machine with
`docker` and `docker-compose` installed.

## Usage

### Local usage

To run your CMS locally and access it via [http://localhost](http://localhost),
you just have to run

```shell
MYSQL_ROOT_PASSWORD=xxx MYSQL_USER=anchor MYSQL_PASSWORD=xxx docker-compose up
```

(you can also change the `MYSQL_USER` to whatever you like).

This will pull the necessary images from DockerHub and run them.

### Set up your blog.

If your blog is already set up (which means a database exists and can be found
in `./volumes/mysql`) you won't have to worry about that. (In other words, if
you already have a blog set up, dump your MYSQL `/var/lib/mysql` folder into
`./volumes/mysql`, remove the `/var/www/anchor/install` folder (see next
section) and re-run the `docker-compose up` command above, everything should be
running. Otherwise, access `http://localhost/install` in your browser and
follow the instructions.

When asked for database credentials, as an hostname, put the IP Adress that
appears when you run:

```shell
docker inspect anchor_db | grep "\"IPAddress\":"
```

Put the username and password you used when running the `docker-compose up`
command (as well as the database name) and everything should work like a charm.

When done, done forget to deleate the install folder.

### Remove the install folder (CRUCIAL IN PROD)

Once the database is setup, delete the `install` folder in your Anchor root
directory:

```shell
docker exec -it anchor_server rm -rf /var/www/anchor/install
```

**Don't forget to do this in production or else, everone will be able to reset
your blog and get admin rights!!**

### Back up the MySQL database and your `./volumes/anchor/themes` folder

To avoid loosing the articles you wrote, you can easily back your database up
and restore it later by running `./db_backup.sh`. This will create a
`./backups` folder if it doesn't exist and put a dated backup of your
`./volumes/mysql` folder in there. Keep it safe.

If you're using custom themes or customizing the default theme, it's also
advised that you back up your `./volumes/anchor/themes` folder at regular
interval.

Finally, if you spawn up a new container for an already existing Anchor CMS
installation, copy your old `anchor/config` and `content` directories to
`./volumes/anchor` before running the container as well.

### Using the image in Production (and keep track of HTTP and MySQL logs)

TODO: ECS, GCP, On-Prem' Kubernetes

## Todos:

* Write a little piece of something about how to deal with logging locally and
  above all, in the cloud (FluentD + ElasticSearch seems to be a good solution,
  this have to be digged into)
* Write a little something about deploying that on ECS and on Kubernetes
* In the above article, insist on the centralized storage option for the
  containers' volumes (and suggest a simple, regular S3 backup for a single
  host configuration)

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

* January 2016: switched to Anchor CMS, the docker image works and has been
pushed to Dockerhub, I'll start using it for [my personal
blog](http://blog.elafarge.net).
* December 2015: first satisfying proof-of-concept

## Contributors

* Etienne LAFARGE (etienne.lafarge_at_gmail.com)

## License

GNU GPLv3
