# Managing python via uv

**Last updated as part of: v0.4.24**

If Python is already installed on your system, uv will detect and use it without configuration. However, uv can also install and manage Python versions for you.

To install the latest Python version:

```bash
uv python install
```

This will install a uv-managed Python version even if there is already a Python installation on your system. If you've previously installed Python with uv, a new version will not be installed.

## Installing a specific version

To install a specific Python version:

```bash
uv python install 3.12
```

To install multiple Python versions:

```bash
uv python install 3.11 3.12
```

To install an alternative Python implementation, e.g. PyPy:

```bash
uv python install pypy@3.12
```

## Viewing python installations

To view available and installed Python versions:

```bash
uv python list
```
