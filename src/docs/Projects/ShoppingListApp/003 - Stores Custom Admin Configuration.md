# Background

- [Issue](https://github.com/Evanlab02/ShoppingListApp/issues/87)
- [Branch](https://github.com/Evanlab02/ShoppingListApp/tree/87-stores-custom-admin-configuration)
- [PR](https://github.com/Evanlab02/ShoppingListApp/pull/219)

## Description

We would like to flesh out the admin page capabilities and interactions with store models.

Resources:

- [Django Documentation](https://docs.djangoproject.com/en/5.1/ref/contrib/admin/)

### Acceptance criteria

Scenario 1: We would like to be able to bulk update the store type within in the admin page.  
Given: User is logged into admin page and viewing stores  
When: User is selecting multiple stores  
Then: User should be able to bulk update stores to update the store type.

Scenario 2: We Would like to be able to filter by store type within in the admin page.  
Given: User is logged into admin page and viewing stores  
When: User is filtering the stores  
Then: User should be able to filter by store type.

Scenario 3: We would like to be able to see all fields on the admin page.  
Given: User is logged into admin page  
When: User is viewing stores  
Then: User should be able to view all the fields of each store in the row.

**We should also add documentation on the new admin page to explain how it works and can be utilized.**

### Bonus

Some things that would be nice to have but there is some uncertainty:

- Date filtering.
- Admin documentation (using the django standard way).
- Client model admin configuration.
- Clean-up compose files.
- Add documentation on development getting started.

## Outcome

**NOTE: I accidentally pushed some changes straight to trunk.**

### We would like to be able to see all fields on the admin page.

Created a `StoreAdmin` class to allow for custom admin configuration and updated the list_display value with the fields we would like to see on the admin page.

```python
"""Contains the admin configuration for the stores app."""

import logging

from django.contrib import admin
from django.contrib.admin import ModelAdmin

from stores.models import ShoppingStore as Store

log = logging.getLogger(__name__)
log.info("Loading stores admin config...")


class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""
	
    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]


admin.site.register(Store, StoreAdmin)

log.info("Loaded stores admin config.")
```

### We Would like to be able to filter by store type within in the admin page.  

Updated the `list_filter` field to include fields we would like to filter by, added some extras as they were easy to add.

```python
class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""
	
    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]
    list_filter = ["store_type", "user", "created_at", "updated_at"]
```

### We would like to be able to bulk update the store type within in the admin page. 

Updated the actions on the model, and created the update functions for it.

```python
class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""

    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]
    list_filter = ["store_type", "user", "created_at", "updated_at"]
    actions = ["make_online", "make_in_store", "make_online_and_in_store"]

    @admin.action(description="Mark selected stores as online.")
    def make_online(self, request, queryset) -> None:  # type: ignore
        """Update all selected stores to be online."""
        queryset.update(store_type=1)

    @admin.action(description="Mark selected stores as in-store.")
    def make_in_store(self, request, queryset) -> None:  # type: ignore
        """Update all selected stores to be in-store."""
        queryset.update(store_type=2)

    @admin.action(description="Mark selected stores as online and in-store.")
    def make_online_and_in_store(self, request, queryset) -> None:  # type: ignore
        """Update all selected stores as online and in-store."""
        queryset.update(store_type=3)
```

### Admin Documentation

Used the guide here to implement built-in django admin documentation: https://docs.djangoproject.com/en/5.1/ref/contrib/admin/admindocs/
I do not think this delivers any value as of right now, but thought it was a nice to have.
