# Running scripts

**Last updated as part of: v0.4.24**

With uv you can run scripts with their dependencies.

Given you have a file with `rich` as a dependency:

```python
import time
from rich.progress import track

for i in track(range(20), description="For example:"):
    time.sleep(0.05)
```

You can run this script with the following command: 

```bash
uv run --with rich example.py
```
## Creating python scripts

You can create scripts with uv with the following command:

```bash
uv init --script example.py --python 3.12
```

This will attach inline script metadata inline with PEP. 
You can also dependencies to the script, for example:

```bash
uv add --script example.py 'requests<3' 'rich'
```
