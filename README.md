# Orchestrating Using Docker Compose

## Learning Goals

- Understanding multi application setup in Docker Compose

## Instructions

For all our use cases of containers up until now, we've been manually administering individual containers using the Docker CLI. This works for 
simple cases, like demonstration and one-off systems, but isn't really viable for anything more complex. When you think about scaling containers,
a lot of potential problems probably come to mind about how to move from the single-container/single-node setup, to scaling across
entire datacenters and regions. This is where Container Orchestration comes into play.
We will have a brief overview of Kubernetes as the major Orchestration player in a later lesson, but in here we are covering Docker Compose for the
purposes of local development. Docker Compose still does fit as a valid tool for developmental clustering/orchestration, and single-node Docker environments.

## First Hands-On with Docker Compose

First, take a look at the below two links, and run through these for a quick Docker Compose primer. This should take you through the bare minimum to understand
a simple Compose use case.

- [Docker Compose](https://docs.docker.com/compose/)
- [Using Docker Compose](https://docs.docker.com/get-started/08_using_compose/)

If you ever find yourself needing to use Docker Compose more extensively, there is a vast amount of definitive sources available in the Docker documentation you should
read though. The specification for the Docker Compose file alone is an ~90 minute read.

## Multi-Layer Application in Docker Compose

Now that you have a better understanding of how Docker Compose maps to how we've been utilizing Docker environments prior, go ahead and migrate our previous Postgres cluster
environment into Docker Compose. There is a starter `docker-compose.yml` file included in this lab repository to get a jump start from, and a complete working solution in
the `solution` branch.

Once done, your environment should be composed of the following:

- One application container
- One master Postgres container
- Two replica Postgres containers
- One PgPool container


## Testing

The following commands will run the tests to validate that this environment was setup correctly. A screenshot of the successful tests can be uploaded as a submission.

> Note: Docker network and container names are managed by Docker Compose. You may need to change these values if you run Docker Compose in a different directory
> than expected.

``` text
docker run --network java-mod-10-orchestrating-using-compose_default -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/test:/test inspec-lab exec docker.rb
```
``` shell
Profile:   tests from docker.rb (tests from docker.rb)
Version:   (not specified)
Target:    local://
Target ID: 

  ✔  Application Container: Application service named "spring-boot-compose" running correctly
     ✔  #<Inspec::Resources::DockerContainerFilter:0x0000563282738858> with names =~ /spring-boot-compose/ image == "rest-service-complete:0.0.1-SNAPSHOT" ports =~ /0.0.0.0:8080/ status is expected to match [/Up/]
     ✔  HTTP GET on http://spring-boot-compose:8080/ status is expected to eq 404
  ✔  Postgres Master Running: Postgres Master service named "postgres-compose-master-1" is running
     ✔  #<Inspec::Resources::DockerImageFilter:0x0000563281096050> with repository == "bitnami/postgresql-repmgr" tag == "14.4.0-debian-11-r9" is expected to exist
     ✔  #<Inspec::Resources::DockerContainerFilter:0x00005632805ac360> with names =~ /postgres-compose-master-1/ image == "bitnami/postgresql-repmgr:14.4.0-debian-11-r9" status is expected to match [/Up/]
     ✔  PostgreSQL query: SELECT datname FROM pg_database; output is expected to include "db_test"
  ✔  Postgres Replica 1 Running: Postgres Replica 1 service named "postgres-compose-replica-1" is running
     ✔  #<Inspec::Resources::DockerContainerFilter:0x000056328275e558> with names =~ /postgres-compose-replica-1/ image == "bitnami/postgresql-repmgr:14.4.0-debian-11-r9" status is expected to match [/Up/]
     ✔  PostgreSQL query: SELECT datname FROM pg_database; output is expected to include "db_test"
  ✔  Postgres Replica 2 Running: Postgres Replica 2 service named "postgres-compose-replica-2" is running
     ✔  #<Inspec::Resources::DockerContainerFilter:0x000056328285d530> with names =~ /postgres-compose-replica-2/ image == "bitnami/postgresql-repmgr:14.4.0-debian-11-r9" status is expected to match [/Up/]
     ✔  PostgreSQL query: SELECT datname FROM pg_database; output is expected to include "db_test"
  ✔  PgPoolII Running: PgPoolII service named "pgpool-compose" is running
     ✔  #<Inspec::Resources::DockerImageFilter:0x00005632829ff438> with repository == "bitnami/pgpool" tag == "4.3.2-debian-11-r16" is expected to exist
     ✔  #<Inspec::Resources::DockerContainerFilter:0x0000563281091be0> with names =~ /pgpool-compose/ image == "bitnami/pgpool:4.3.2-debian-11-r16" status is expected to match [/Up/]
     ✔  PostgreSQL query: SELECT datname FROM pg_database; output is expected to include "db_test"
  ✔  PgPoolII Nodes Connected: PgPoolII Backend Nodes Online
     ✔  PostgreSQL query: SHOW POOL_NODES; output is expected to match "postgres-compose-master-1" and match "postgres-compose-replica-1" and match "postgres-compose-replica-2"


Profile Summary: 6 successful controls, 0 control failures, 0 controls skipped
Test Summary: 13 successful, 0 failures, 0 skipped
```
``` text
docker run --network java-mod-10-orchestrating-using-compose_default -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd)/test:/test inspec-lab exec postgres.rb -t docker://java-mod-10-orchestrating-using-compose_postgres-compose-master-1_1
```
``` shell
Profile:   tests from postgres.rb (tests from postgres.rb)
Version:   (not specified)
Target:    docker://695fb0406f730d0d51c6874c9adbb8a53b72837dce9de1e681f773b6a0754ff9
Target ID: da39a3ee-5e6b-5b0d-b255-bfef95601890

  ✔  RepMgr Nodes Connected: RepMgr Backend Nodes Online
     ✔  Command: `/opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh repmgr -f /opt/bitnami/repmgr/conf/repmgr.conf cluster show` stdout is expected to match "postgres-compose-master-1" and match "postgres-compose-replica-1" and match "postgres-compose-replica-2"


Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 1 successful, 0 failures, 0 skipped
```


## Advanced lab

If you still have time after completing the above, go ahead and scale out the application layer to a few containers. Use Traefik to load balance the web traffic.
Web Load Balancing is its own complex topic, but this guide should be straightforward enough to provide a good demonstration.

- [Traefik for Docker Compose](https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/)
