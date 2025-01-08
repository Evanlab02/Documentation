# Strings

## Combining two strings (Concatenating two strings)

```C
#include <string.h>
char actual[16] = {0};
strcat(actual, "Ping");
strcat(actual, "Pong");

// Actual = "PingPong"
```

## Adding integers into strings (and other data types)

```C
#include <stdio.h>
char actual[16] = {0};
snprintf(actual, 16, "%d", 202);

// Actual = "202"
```
