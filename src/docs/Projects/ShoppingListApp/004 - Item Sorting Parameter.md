# Background

- [Issue](https://github.com/Evanlab02/ShoppingListApp/issues/132)
- [PR](https://github.com/Evanlab02/ShoppingListApp/pull/221)
## Description

We currently do not support sorting the data we receive from the API when it comes to the items listing.

We would like to add this functionality as it can be useful to see values alphabetically or by date created etc.
### Acceptance Criteria

- AC1 - Add item sorting to `/api/v1/items` endpoint.
- AC2 - Add item sorting to `/api/v1/items/me` endpoint.
- AC3 - Add item sorting to `/api/v1/items/search` endpoint.
- AC4 - Should allow sorting for all of the following fields:
	- `name`
	- `price`
	- `created_on`
	- `updated_on`
- BONUS - Document our github workflows in a high level + low level for the build.yaml file
	- Improve where necessary.

## Outcome

### Can now sort items

On the following endpoints, we can now sort, using a combination of  the `sort` and `sort_dir` parameters:

- `/api/v1/items/`
- `/api/v1/items/me`
- `/api/v1/items/search`

### Improved the `build.yml` action file

- Better whitespace around steps.
- Now use uv to download dependencies to speed it up and also prepare for uv migration.
- Added documentation for this action file.

### Identified areas for improvement in upcoming tasks

- Within `item_service` when using the `search_items` functionality. We are querying stores when it is not necessary doing unnecessary hits on the DB. We should rather use store IDs and pass them into the repository.
- We should migrate the backend away from `pipenv` and to `uv`.
- We need to update the sonarcloud action to the new updated one.
- Update dependencies before next release.
