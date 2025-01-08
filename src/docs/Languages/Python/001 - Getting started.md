# Getting started with Python

I would recommend using [pyenv](https://github.com/pyenv/pyenv) to install python. I would highly advise against using any built-in python versions that come with your OS, if there are any.

## pyenv installation and setup

**NOTE: The below steps are assuming you are using Ubuntu/Debian with bash:**

```bash
curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

exec "$SHELL"

sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

### Install python using pyenv

```bash
pyenv install 3.13
```

### Use python version for current directory/project

```bash
pyenv local 3.13
```

### Use python version globally

```bash
pyenv global 3.13
```

## Simple python program

```python
"""
Main module for the program.
"""

import sys


def main():
	"""Entry point for the program."""
    print("Hello World!")
    return 0


if __name__ == "__main__":
    EXIT = main()
    sys.exit(EXIT)
```

