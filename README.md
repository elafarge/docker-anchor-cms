# Docker: Bolt CMS

A docker container (actually, there's two docker containers in the final app.
but one of them is just the stock MySQL one) all set to run Bolt CMS and create
a containerized website or blog in minutes.

### Global architecture

#### Why MySQL ?

Well, it would have been great to use `postgres` instead (at least just for its
awesome CLI client), acknowledged. But so far, Bolt CMS hasn't been supporting
`postgres` very well that's why we preferred to stick to `MySQL/MariaDB`.
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
MYSQL_ROOT_PASSWORD=xxx MYSQL_USER=bolt MYSQL_PASSWORD=xxx docker-compose up
```

(you can change the `MYSQL_USER` to whatever you like)

### Remove the install folder

Once the database is setup, delete the `install` folder in your Anchor root
directory:

```shell
docker exec -it anchor_server rm -rf /var/www/anchor/install
```

### Using the image on DockerHub

TODO: ECS, GCP, On-Prem' Kubernetes

## Todos:

* Accept MySQL password changes in the container's startup script (just like
  for the IP)
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

December 2015: first satisfying proof-of-concept

## Contributors

* Etienne LAFARGE (etienne.lafarge_at_gmail.com)

## License

GNU GPLv3
