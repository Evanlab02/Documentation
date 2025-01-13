# Background

- [Issue](https://github.com/Evanlab02/DockerLens/issues/24)
- PR (Pending)

## Description

Create a HTTP JSON streaming endpoint on the PHP application. This will be streaming the data from Docker for container resources and acts as a middle man.

### Acceptance criteria

AC1 - Create `/api/v1/resources` endpoint.
AC2 - Return data in JSON stream.
AC3 - Only return the following data
AC3.1 - CPU Usage %
AC3.2 - Memory usage %
AC3.3 - These values are not provided, but are calculated based on the data from Docker. Calculate this on the BE.
