# Configuring your admin models

To register an admin interface for your models, you do something similar to the following:

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

    pass


admin.site.register(Store, StoreAdmin)

log.info("Loaded stores admin config.")
```

## Update what gets displayed on the list view

To update what gets displayed on the list view for the models/rows, you can update the `list_display` value on the admin model, example below:

```python
class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""

    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]
```

## Update what filters are available

To update what filtering is possible on the list view for the models/rows, you can update the `list_filter` value on the admin model, example below:

```python
class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""

    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]
    list_filter = ["store_type", "user", "created_at", "updated_at"]
```

You can also use search bar to filter stores, you should specify what fields should be searched, example below:

```python
class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""

    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]
    list_filter = ["store_type", "user", "created_at", "updated_at"]
    search_fields = ["name", "description"]
```

## Create actions

You can create pre-determined actions for bulk updating your models in the admin page, you can do as in the example below:

```python
class StoreAdmin(ModelAdmin):  # type: ignore
    """Admin configuration class for store models."""
	
    list_display = ["name", "store_type", "description", "created_at", "updated_at", "user"]
    list_filter = ["store_type", "user", "created_at", "updated_at"]
    search_fields = ["name", "description"]
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
