# Background

- Branch (Pending)
- [Issue](https://github.com/Evanlab02/DockerLens/issues/8)
- PR (Pending)

## Description

Currently we only retrieve running containers from the docker API, we should update the query to include all containers regardless of state.

### Acceptance Criteria

Scenario 1: We would like to be able to view all containers running on the containers list page.  
Given: User is on the containers page  
When: User is viewing the containers in the table  
Then: User should be able to see all running containers.

## Outcome
