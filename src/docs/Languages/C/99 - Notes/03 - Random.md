# Using random values

## Random integer in range

```C
#include <stdlib.h>
#include <time.h>

srand(time(NULL));
int min = 1;
int max = 6;
int random_number = (rand() % (max - min + 1)) + min;
```
