# Background

- Branch (Pending)
- [Issue](https://github.com/Evanlab02/DockerLens/issues/9)
- PR (Pending)

## Description

To be more clear to the user, we should add colours to the state of the containers to illustrate what the container state is.

### Acceptance Criteria

Scenario 1: We would like to be able to see all containers that are running as a green colour.  
Given: User is on the containers page  
When: User is viewing the containers in the table  
Then: User should be able to see all containers with the running state having a green colour.

Scenario 2: We would like to be able to see all containers that are paused as an amber colour.  
Given: User is on the containers page  
When: User is viewing the containers in the table  
Then: User should be able to see all containers with the paused state having an amber colour.

Scenario 1: We would like to be able to see all containers that are paused as a red colour.  
Given: User is on the containers page  
When: User is viewing the containers in the table  
Then: User should be able to see all containers with the exited/restarting state having a red colour.

## Outcome
