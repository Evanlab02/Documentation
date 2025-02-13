# uv - pip-tools

`uv`  allows us to lock dependencies and create requirements.txt from those pinned versions files.

Similarly to how we would with `pip-tools` (or `pip-compile`).

## Start a uv project

To have an environment to be able demonstrate this behaviour, start a uv project with the following commands:

```bash
uv init Play
cd Play
uv add fastapi[all]
```

## Create a requirements.txt file with pinned versions

To create our requirements.txt file, we can use the following command:

```bash
uv pip compile -o requirements.txt pyproject.toml
```

We should get something similar to the following:

```txt
# This file was autogenerated by uv via the following command:
#    uv pip compile -o requirements.txt pyproject.toml
annotated-types==0.7.0
    # via pydantic
anyio==4.7.0
    # via
    #   httpx
    #   starlette
    #   watchfiles
certifi==2024.8.30
    # via
    #   httpcore
    #   httpx
click==8.1.7
    # via
    #   rich-toolkit
    #   typer
    #   uvicorn
dnspython==2.7.0
    # via email-validator
email-validator==2.2.0
    # via fastapi
fastapi==0.115.6
    # via play (pyproject.toml)
fastapi-cli==0.0.6
    # via fastapi
h11==0.14.0
    # via
    #   httpcore
    #   uvicorn
httpcore==1.0.7
    # via httpx
httptools==0.6.4
    # via uvicorn
httpx==0.28.1
    # via fastapi
idna==3.10
    # via
    #   anyio
    #   email-validator
    #   httpx
itsdangerous==2.2.0
    # via fastapi
jinja2==3.1.4
    # via fastapi
markdown-it-py==3.0.0
    # via rich
markupsafe==3.0.2
    # via jinja2
mdurl==0.1.2
    # via markdown-it-py
orjson==3.10.12
    # via fastapi
pydantic==2.10.3
    # via
    #   fastapi
    #   pydantic-extra-types
    #   pydantic-settings
pydantic-core==2.27.1
    # via pydantic
pydantic-extra-types==2.10.1
    # via fastapi
pydantic-settings==2.6.1
    # via fastapi
pygments==2.18.0
    # via rich
python-dotenv==1.0.1
    # via
    #   pydantic-settings
    #   uvicorn
python-multipart==0.0.19
    # via fastapi
pyyaml==6.0.2
    # via
    #   fastapi
    #   uvicorn
rich==13.9.4
    # via
    #   rich-toolkit
    #   typer
rich-toolkit==0.12.0
    # via fastapi-cli
shellingham==1.5.4
    # via typer
sniffio==1.3.1
    # via anyio
starlette==0.41.3
    # via fastapi
typer==0.15.1
    # via fastapi-cli
typing-extensions==4.12.2
    # via
    #   fastapi
    #   pydantic
    #   pydantic-core
    #   pydantic-extra-types
    #   rich-toolkit
    #   typer
ujson==5.10.0
    # via fastapi
uvicorn==0.32.1
    # via
    #   fastapi
    #   fastapi-cli
uvloop==0.21.0
    # via uvicorn
watchfiles==1.0.3
    # via uvicorn
websockets==14.1
    # via uvicorn
```

### Removing annotations

To remove the annotations (example: `# via uvicorn`), we can use another command line argument, as below:

```bash
uv pip compile --no-annotate -o requirements.txt pyproject.toml
```

Output:

```txt
# This file was autogenerated by uv via the following command:
#    uv pip compile --no-annotate -o requirements.txt pyproject.toml
annotated-types==0.7.0
anyio==4.7.0
certifi==2024.8.30
click==8.1.7
dnspython==2.7.0
email-validator==2.2.0
fastapi==0.115.6
fastapi-cli==0.0.6
h11==0.14.0
httpcore==1.0.7
httptools==0.6.4
httpx==0.28.1
idna==3.10
itsdangerous==2.2.0
jinja2==3.1.4
markdown-it-py==3.0.0
markupsafe==3.0.2
mdurl==0.1.2
orjson==3.10.12
pydantic==2.10.3
pydantic-core==2.27.1
pydantic-extra-types==2.10.1
pydantic-settings==2.6.1
pygments==2.18.0
python-dotenv==1.0.1
python-multipart==0.0.19
pyyaml==6.0.2
rich==13.9.4
rich-toolkit==0.12.0
shellingham==1.5.4
sniffio==1.3.1
starlette==0.41.3
typer==0.15.1
typing-extensions==4.12.2
ujson==5.10.0
uvicorn==0.32.1
uvloop==0.21.0
watchfiles==1.0.3
websockets==14.1
```

### Disclaimer

You can also use `uv pip compile` with a requirements.in file instead of a pyproject.toml, allowing you to use uv as a replacement for pip-tools without changing too much about your environment.
### Shortcomings

#### Dev dependencies with pyproject.toml

You can not create a file for dev dependencies using the pyproject.toml file so you will need to use a requirements.in file. So lets do that for some dev dependencies:

```in
# requirements.dev.in
black
flake8
pytest
mypy
```

To create a requirements.dev.txt file for these, we can do the following:

```bash
uv pip compile --no-annotate -o requirements.dev.txt requirements.dev.in
```

Which will look like the following:

```txt
# This file was autogenerated by uv via the following command:
#    uv pip compile --no-annotate -o requirements.dev.txt requirements.dev.in
black==24.10.0
click==8.1.7
flake8==7.1.1
iniconfig==2.0.0
mccabe==0.7.0
mypy==1.13.0
mypy-extensions==1.0.0
packaging==24.2
pathspec==0.12.1
platformdirs==4.3.6
pluggy==1.5.0
pycodestyle==2.12.1
pyflakes==3.2.0
pytest==8.3.4
typing-extensions==4.12.2
```

And then finally we can add the dependencies to the pyproject.toml with the following command while still having a dev requirements.txt

```bash
uv add --dev -r requirements.dev.txt
```
