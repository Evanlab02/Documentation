# HTTP Methods
## Defining operations

An `operation` can be one of the following [HTTP methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods):

- GET
- POST
- PUT
- DELETE
- PATCH

**Django Ninja** comes with a decorator for each operation:

```python
@api.get("/path")
def get_operation(request):
    ...

@api.post("/path")
def post_operation(request):
    ...

@api.put("/path")
def put_operation(request):
    ...

@api.delete("/path")
def delete_operation(request):
    ...

@api.patch("/path")
def patch_operation(request):
    ...
```
See the [operations parameters](https://django-ninja.dev/reference/operations-parameters/) reference docs for information on what you can pass to any of these decorators.

## Handling multiple methods

If you need to handle multiple methods with a single function for a given path, you can use the `api_operation` decorator:

```python
@api.api_operation(["POST", "PATCH"], "/path")
def mixed_operation(request):
    ...
```

This feature can also be used to implement other HTTP methods that don't have corresponding **Django Ninja** methods, such as `HEAD` or `OPTIONS`.

```python
@api.api_operation(["HEAD", "OPTIONS"], "/path")
def mixed_operation(request):
    ...
```
