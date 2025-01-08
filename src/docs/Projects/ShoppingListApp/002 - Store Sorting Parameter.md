# Background

- [Issue](https://github.com/Evanlab02/ShoppingListApp/issues/88)
- [Branch](https://github.com/Evanlab02/ShoppingListApp/tree/88-store-sorting-parameter)
- [PR](https://github.com/Evanlab02/ShoppingListApp/pull/218)
## Description

We currently do not support sorting the data we receive from the API when it comes to the stores listing.

We would like to add this functionality as it can be useful to see values alphabetically or by date created etc.
### Acceptance Criteria

- AC1 - Add store sorting to `/api/v1/stores` endpoint.
- AC2 - Add store sorting to `/api/v1/stores/me` endpoint.
- AC3 - Add store sorting to `/api/v1/stores/search` endpoint.
- AC4 - Should allow sorting for all of the following fields:
	- `name`
	- `created_on`
	- `updated_on`
- BONUS - Add documentation on the code pattern for views.
## Outcome

### Updated store repo to allow for sorting

Updated the `get_stores` and `filter_stores` functions to allow for sorting parameters that will be passed to the`_filter` function.

```python
async def get_stores(
    page_number: int = 1,
    stores_per_page: int = 10,
    user: User | None = None,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Get all stores.

    Args:
        page (int): The page number, default to 1.
        stores_per_page (int): The number of stores per page, default to 10.
        user (User | None): User who owns the stores.
        sort (str | None): The field to sort by.
        dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: Store pagination object.
    """
    return await _filter(page_number, stores_per_page, user=user, sort=sort, sort_dir=sort_dir)
```

```python
async def filter_stores(
    page_number: int = 1,
    stores_per_page: int = 10,
    name: str | None = None,
    store_types: list[int] | None = None,
    created_on: date | None = None,
    created_before: date | None = None,
    created_after: date | None = None,
    updated_on: date | None = None,
    updated_before: date | None = None,
    updated_after: date | None = None,
    user: User | None = None,
    ids: list[int] | None = None,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Filter stores.

    Args:
        page_number (int): The page number.
        stores_per_page (int): The number of stores per page.
        name (str | None): The name of the store.
        store_types (list[int] | None): The store types.
        created_on (date | None): The date the store was created.
        created_before (date | None): The date the store was created before.
        created_after (date | None): The date the store was created after.
        updated_on (date | None): The date the store was updated.
        updated_before (date | None): The date the store was updated before.
        updated_after (date | None): The date the store was updated after.
        user (User | None): The user who created the store.
        ids (list[int] | None): The store ids to filter from.
        sort (str | None): The field to sort by.
        dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: Store pagination object.
    """
    return await _filter(
        page_number,
        stores_per_page,
        name,
        store_types,
        created_on,
        created_before,
        created_after,
        updated_on,
        updated_before,
        updated_after,
        user,
        ids=ids,
        sort=sort,
        sort_dir=sort_dir
    )
```

Updated the private `_filter` function to allow for sorting.
First I updated the function declaration:

```python
def _filter(
    page_number: int = 1,
    stores_per_page: int = 10,
    name: str | None = None,
    store_types: list[int] | None = None,
    created_on: date | None = None,
    created_before: date | None = None,
    created_after: date | None = None,
    updated_on: date | None = None,
    updated_before: date | None = None,
    updated_after: date | None = None,
    user: User | None = None,
    ids: list[int] | None = None,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
```

Second, I added code for sorting logic:

```python
	sort_field = sort or "updated_at"
    prefix = "-" if sort_dir == "desc" else ""
    stores = stores.order_by(f"{prefix}{sort_field}")
```

And I added three tests for this functionality:

- stores/tests/database/test_store_repo_get.py
	- async def test_get_stores_with_sort_dir(self) -> None:
	- async def test_get_stores_with_sort(self) -> None:
	- async def test_get_stores_with_sort_and_dir(self) -> None:

### Updated store service to allow for sorting

Updated the two functions below to allow for this:

```python
async def get_stores(
    limit: int = 10,
    page_number: int = 1,
    user: Any | None = None,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Get the stores.

    Args:
        limit (int): The limit of stores per page, defaults 10.
        page_number (int): The page number, defaults to 1.
        user (User): User who created the stores.
        sort (str | None): The field to sort by.
        sort_dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: The stores in a paginated format.
    """
    log.info(f"Retrieving stores for page {page_number} with limit {limit}...")
    paginated_stores = await store_repo.get_stores(page_number, limit, user, sort, sort_dir)
    return paginated_stores
```

```python
async def search_stores(
    page: int = 1,
    limit: int = 10,
    name: str | None = None,
    user: Any | None = None,
    ids: list[int] | None = None,
    store_types: list[int] | None = None,
    created_on: date | None = None,
    created_before: date | None = None,
    created_after: date | None = None,
    updated_on: date | None = None,
    updated_before: date | None = None,
    updated_after: date | None = None,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Search for stores based on criteria.

    Args:
        page (int): The page number.
        limit (int): The number of stores per page.
        name (str): Partial or full name of store.
        user (User): The user that owns the store.
        ids (list[int]): List of ids to filter from.
        store_types (list[int]): List of store types to filter from.
        created_on (date): The date the store was created.
        created_before (date): Date the store was created before.
        created_after (date): Date the store was created after.
        updated_on (date): Date the store was last updated.
        updated_before (date): Date the store was last updated before.
        updated_after (date): Date the store was last updated after.
        sort (str | None): The field to sort by.
        sort_dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: The schema result which contains the stores that were searched for.
    """
    log.info(f"PAGE NO - {page}")
    log.info(f"LIMIT - {limit}")
    log.info(f"STORE TYPES - {store_types}")
    log.info(f"CREATED ON - {created_on}")
    log.info(f"CREATED BEFORE - {created_before}")
    log.info(f"CREATED AFTER - {created_after}")
    log.info(f"UPDATED ON - {updated_on}")
    log.info(f"UPDATED BEFORE - {updated_before}")
    log.info(f"UPDATED AFTER - {updated_after}")
    log.info(f"IDS - {ids}")
    return await store_repo.filter_stores(
        page_number=page,
        stores_per_page=limit,
        name=name,
        user=user,
        store_types=store_types,
        created_on=created_on,
        created_before=created_before,
        created_after=created_after,
        updated_on=updated_on,
        updated_before=updated_before,
        updated_after=updated_after,
        ids=ids,
        sort=sort,
        sort_dir=sort_dir,
    )
```

### Updated routers/endpoints to allow for sorting

Updated the endpoints:

-  `/api/v1/stores`
- `/api/v1/stores/me` 
- `/api/v1/stores/search`

```python
@store_router.get("", response={200: StorePaginationSchema})
async def get_stores(
    request: HttpRequest,
    limit: int = 10,
    page: int = 1,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Get the stores.

    Args:
        request (HttpRequest): The HTTP request.
        limit (int): The limit of stores to get per page.
        page (int): The page number.
        sort (str | None): The field to sort by.
        sort_dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: The stores.
    """
    log.info(f"User requested stores with limit ({limit}) for page: {page}.")
    result = await store_service.get_stores(limit, page, sort=sort, sort_dir=sort_dir)
    return result
```

```python
@store_router.get("/me", response={200: StorePaginationSchema})
async def get_personal_stores(
    request: HttpRequest,
    limit: int = 10,
    page: int = 1,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Get the stores you have created.

    Args:
        request (HttpRequest): The HTTP request.
        limit (int): The limit of stores to get per page.
        page (int): The page number.
        sort (str | None): The field to sort by.
        sort_dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: The stores.
    """
    user = await request.auser()
    log.info(f"User requested personal stores with limit ({limit}) for page: {page}.")
    result = await store_service.get_stores(limit, page, user, sort, sort_dir)
    return result
```

```python
@store_router.post("/search", response={200: StorePaginationSchema})
async def search(
    request: HttpRequest,
    filters: StoreSearch,
    page: int = 1,
    limit: int = 10,
    name: str | None = None,
    own: bool = False,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Perform search for stores.

    Args:
        request (HttpRequest): The HTTP request to the API.
        filters (StoreSearch): The body containing the filters.
        page (int): The page number.
        limit (int): The number of stores per page.
        name (str): Full or partial name to search for.
        own (bool): Flag indicating if you would like to see only your own stores.
        sort (str | None): The field to sort by.
        sort_dir (str | None): The direction to sort in.

    Returns:
        StorePaginationSchema: The stores in a paginated response.
    """
    user = None
    if own:
        user = await request.auser()

    log.info("User searching stores...")

    return await store_service.search_stores(
        page=page,
        limit=limit,
        name=name,
        user=user,
        ids=filters.ids,
        store_types=filters.store_types,
        created_on=filters.created_on,
        created_before=filters.created_before,
        created_after=filters.created_after,
        updated_on=filters.updated_on,
        updated_before=filters.updated_before,
        updated_after=filters.updated_after,
        sort=sort,
        sort_dir=sort_dir,
    )
```
### Refactor/Optimize `_filter` function

Updated the `_filter` function in an attempt to optimize it. Use entirely async code where possible now instead of using the pagination class.

```python
async def _filter(
    page_number: int = 1,
    stores_per_page: int = 10,
    name: str | None = None,
    store_types: list[int] | None = None,
    created_on: date | None = None,
    created_before: date | None = None,
    created_after: date | None = None,
    updated_on: date | None = None,
    updated_before: date | None = None,
    updated_after: date | None = None,
    user: User | None = None,
    ids: list[int] | None = None,
    sort: Literal["name", "created_on", "updated_on"] | None = None,
    sort_dir: Literal["asc", "desc"] | None = None,
) -> StorePaginationSchema:
    """
    Filter stores.

    Args:
        page_number (int): The page number.
        stores_per_page (int): The number of stores per page.
        name (str | None): The name of the store.
        store_types (list[int] | None): The store types.
        created_on (date | None): The date the store was created.
        created_before (date | None): The date the store was created before.
        created_after (date | None): The date the store was created after.
        updated_on (date | None): The date the store was updated.
        updated_before (date | None): The date the store was updated before.
        updated_after (date | None): The date the store was updated after.
        user (User | AnonymousUser | AbstractBaseUser | None): The user who created the store.
        ids (list[int] | None): The ids to filter from.

    Returns:
        StorePaginationSchema: Store pagination object.
    """
    stores = Store.objects.select_related("user").all()

    if ids:
        stores = stores.filter(id__in=ids)
    if name:
        stores = stores.filter(name__icontains=name)
    if store_types:
        stores = stores.filter(store_type__in=store_types)
    if created_on:
        stores = stores.filter(created_at__date=created_on)
    if created_before:
        stores = stores.filter(created_at__date__lte=created_before)
    if created_after:
        stores = stores.filter(created_at__date__gte=created_after)
    if updated_on:
        stores = stores.filter(updated_at__date=updated_on)
    if updated_before:
        stores = stores.filter(updated_at__date__lte=updated_before)
    if updated_after:
        stores = stores.filter(updated_at__date__gte=updated_after)
    if user:
        stores = stores.filter(user=user)

    sort_field = sort or "updated_at"
    prefix = "" if sort_dir == "asc" else "-"
    stores = stores.order_by(f"{prefix}{sort_field}")

    start = (page_number - 1) * stores_per_page
    end = start + stores_per_page

    total = await stores.acount()
    total_pages = ceil(total / stores_per_page)

    paginated_stores = stores[start:end]
    results = [StoreSchema.from_orm(store) async for store in paginated_stores]

    has_previous = page_number > 1
    previous_page = page_number - 1 if page_number > 1 else None
    has_next = end < total
    next_page = page_number + 1 if end < total else None

    result = StorePaginationSchema(
        stores=results,
        total=total,
        page_number=page_number,
        total_pages=total_pages,
        has_previous=has_previous,
        previous_page=previous_page,
        has_next=has_next,
        next_page=next_page,
    )

    return result
```
### Added documentation for another code pattern

You can find the updates [here](https://evanlab-gme8r.ondigitalocean.app/shopping/code/pattern/) once they go live.
