### Snippetbox

#### Setup

Since this project uses module vendoring you only need to setup the database. We assume postgres and docker are already present.

To setup the database:

```
TODO: Add sql commands for setting up database, tables, and access permissions.
```

#### Run

##### Locally

FYI: This project assumes that postgres is running locally.

From project root:
```
go build ./cmd/web/
./web
```

##### Docker

The Dockerfile is setup to use the host's network directly.
For now, it's assumed that Postgres is running on the machine also hosting the container.

```
## Test
sudo docker compose up
## Or, Detached
sudo docker compose up -d
```

#### Project Structure

All golang code we write lives under `cmd` and `internal`.

- `cmd` directory contains application-specific code for the executable applications in the project.

- `internal` directory contains ancillary non-application-specific code used in the project. Validation helpers and SQL models mainly.

`ui` directory contains user-interface assets used by the front-end web application. Specifically, html templates, and the `ui/static` directory contains static files like CSS nd images.

We assume Postgres is already running locally. Setup for the database is below.
