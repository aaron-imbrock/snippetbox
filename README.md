### Snippetbox

#### Project Structure

All golang code we write lives under `cmd` and `internal`.

- `cmd` directory contains application-specific code for the executable applications in the project.

- `internal` directory contains ancillary non-application-specific code used in the project. Validation helpers and SQL models mainly.

`ui` directory contains user-interface assets used by the front-end web application. Specifically, html templates, and the `ui/static` directory contains static files like CSS nd images.
