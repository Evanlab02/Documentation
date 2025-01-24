# Caching with django

You can use django's cache framework to utilize various different caching techniques. The below will just cover a basic setup with redis.

## Redis python package

Ensure you have the python redis package installed that django requires.

```bash
pip install redis[hiredis]
```

## Setup up caching in django settings

```python
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379",
    }
}
```

## Per view caching

```python
from django.views.decorators.cache import cache_page


@cache_page(60 * 15) # Seconds to cache for, in this example 15 minutes
def my_view(request): ...
```

## Using the cache framework directly

```python
from django.core.cache import cache

cache.set("my_key", "hello, world!", 30)
cache.get("my_key")
cache.delete("a")
cache.clear()
cache.touch("a", 10)
cache.set("my_key", "hello world!", version=2)
```
