# Background

- [Issue](https://github.com/Evanlab02/ShoppingListApp/issues/95)
- [Branch](https://github.com/Evanlab02/ShoppingListApp/tree/95-argon2-password-hashing)
- [PR](https://github.com/Evanlab02/ShoppingListApp/pull/216)
## Description

We would like to use Argon2 for password hashing instead of the default provided by django. This is to improve security but also to learn new things about hashing.

We will need to update the PASSWORD_HASHERS setting in the settings file, to support the new algorithm (and the old one, so that users can upgrade to Argon2).

We should not force users to have the old password hasher in the settings, and instead should allow a flag that will add this value if the user would like for this to be included, this will allow old users of ShoppingListApp to upgrade and new users to just use it as is.
### Acceptance Criteria

- AC1 - Add Argon2 password hashing as the default.
- AC2 - Add optional env value config that allows the upgrade to Argon2 by adding old hashing algorithms. This will be deprecated in future.
- AC3 - Add optional value that forces the legacy hasher instead of Argon2 to allow users to stay behind. This will be deprecated in future.
- AC4 - Add documentation on the above to V0.18.0 upgrade guide.
- BONUS - Update documentation with regards to the pattern we use for our code in the application.

Created the following issue to keep track of the deprecation coming up: https://github.com/Evanlab02/ShoppingListApp/issues/214
## Outcome

### Add Argon2 password hashing as the default

First I needed to add the Argon2 dependencies to the project to allow django to use it for hashing, this is the updated Pipfile:

```Pipfile
[[source]]
url = "https://pypi.org/simple"
verify_ssl = true
name = "pypi"

[packages]
django = "==5.1.2"
django-ninja = "==1.3.0"
uvicorn = "==0.31.1"
gunicorn = "==23.0.0"
uvicorn-worker = "==0.2.0"
psycopg = {extras = ["binary", "pool"], version = "==3.2.3"}
argon2-cffi = "==23.1.0"

[dev-packages]
black = "==24.10.0"
mypy = "==1.11.2"
flake8 = "==7.1.1"
pydocstyle = "==6.3.0"
pytest = "==8.3.3"
isort = "==5.13.2"
pytest-django = "==4.9.0"
pytest-cov = "==5.0.0"
coverage = "==7.6.2"
requests = "==2.32.3"
types-requests = "==2.32.0.20240914"
selenium = "==4.25.0"
webdriver-manager = "==4.0.2"
pytest-xdist = "==3.6.1"
flake8-docstrings = "==1.7.0"
pytest-sugar = "==1.0.0"
django-stubs = {extras = ["compatible-mypy"], version = "==5.1.0"}

[requires]
python_version = "3.12"
```

And then to add the Argon2 hashing as the default, I changed the settings.py file to contain the following:

```python
PASSWORD_HASHERS = ["django.contrib.auth.hashers.Argon2PasswordHasher"]
```

### Allow for upgrade from old hashing algorithms to Argon2

To allow for the upgrade to Argon2 hashing, I have allowed for env var to adjust the `PASSWORD_HASHERS` value.
This will be allowed if you set the `SHOPPING_ALLOW_LEGACY_HASHING` to a value of `1`.
This will make the preference Argon2, but still allow old hashing algorithms for the passwords that have not changed to this hashing algorithm yet.

**NOTE: This env var will default to 1 if not provided, allowing legacy hashing. This is to allow smooth operating for now. As I get closer to V1, I will be changing this to be defaulted to 0, and then eventually removed**

This was implemented like so:

```python
PASSWORD_HASHERS = ["django.contrib.auth.hashers.Argon2PasswordHasher"]

OPTIONAL_LEGACY_HASHERS = [
    "django.contrib.auth.hashers.Argon2PasswordHasher",
    "django.contrib.auth.hashers.PBKDF2PasswordHasher",
    "django.contrib.auth.hashers.PBKDF2SHA1PasswordHasher",
]

ENABLE_LEGACY_HASHING = getenv("SHOPPING_ALLOW_LEGACY_HASHING", "1")
if ENABLE_LEGACY_HASHING == "1":
    PASSWORD_HASHERS = OPTIONAL_LEGACY_HASHERS
```

### Allow for the forced usage of old hashing algorithms

This is not recommended to use but allows for a fallback if this update fails on your existing passwords for some reason. This is meant to be an escape hatch out of the possibility that something is not working as part of the new release. 

You can force using the legacy password hashers by passing the env var (`SHOPPING_FORCE_LEGACY_HASHING`) as a `1`.
This defaults to `0`.

This was implemented like so:

```python
FORCED_LEGACY_HASHERS = [
    "django.contrib.auth.hashers.PBKDF2PasswordHasher",
    "django.contrib.auth.hashers.PBKDF2SHA1PasswordHasher",
]

FORCE_LEGACY_HASHING = getenv("SHOPPING_FORCE_LEGACY_HASHING", "0")
if FORCE_LEGACY_HASHING == "1":
    PASSWORD_HASHERS = FORCED_LEGACY_HASHERS
```

### Update documentation on these changes for the 0.18.0 upgrade

After these changes are applied, you should be able to view this documentation [here](https://evanlab-gme8r.ondigitalocean.app/shopping/upgrade/0_18_0/).

### Update documentation on some code patterns

After these changes are applied, you should be able to view this documentation [here](https://evanlab-gme8r.ondigitalocean.app/shopping/code/pattern/).
