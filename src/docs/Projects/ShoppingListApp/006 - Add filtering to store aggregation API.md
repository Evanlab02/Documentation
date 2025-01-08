# Background

- [Issue](https://github.com/Evanlab02/ShoppingListApp/issues/134)
- PR (Pending)

## Description

When using the store aggregation API endpoint, we should be able to filter the results we get back. This should be using a similar filter we use for the search or list endpoints.

### Acceptance criteria

Scenario 1: We would like to be able to filter stores that are aggregated.
Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `name`.
Example: `?name=Test`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by a list of `ids`.
Example: `{ids: [1, 2, 3]}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `store_type`.
Example: `{store_types: [1, 2]}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `created_on`.
Example: `{"created_on": ""}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `created_before`.
Example: `{"created_before": ""}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `created_after`.
Example: `{"created_after": ""}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `updated_on`.
Example: `{"updated_on": ""}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `updated_before`.
Example: `{"updated_before": ""}`

Given: User is logged in
When: User hits `/api/v1/stores/aggregate`
Then: User should be able to filter by `updated_after`.
Example: `{"updated_after": ""}`

BONUS:

- Create documentation for `unit-tests.yml` action file.
## Outcome
