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

- [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- [https://docs.docker.com/get-started/08_using_compose/](https://docs.docker.com/get-started/08_using_compose/)

If you ever find yourself needing to use Docker Compose more extensively, there is a vast amount of definitive sources available in the Docker documentation you should
read though. The specification for the Docker Compose file alone is an ~90 minute read.

## Multi-Layer Application in Docker Compose

Now that you have a better understanding of how Docker Compose maps to how we've been utilizing Docker environments prior, go ahead and migrate our previous Postgres cluster
environment into Docker Compose. There is a starter `docker-compose.yml` file included in this lab repository to get a jump start from.

Once done, you environment should be composed of the following:

- One application container
- One master Postgres container
- Two replica Postgres containers
- One PgPool container

## Advanced lab

If you still have time after completing the above, go ahead and scale out the application layer to a few containers. Use Traefik to load balance the web traffic.
Web Load Balancing is its own complex topic, but this guide should be straightforward enough to provide a good demonstration.

- [https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/](https://doc.traefik.io/traefik/user-guides/docker-compose/basic-example/)
