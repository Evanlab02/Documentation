# Define Directives

Reference: [devdocs.io](https://devdocs.io/c/preprocessor/replace)
## Syntax

| Syntax                                                        | Version | Since |
| ------------------------------------------------------------- | ------- | ----- |
| `#define` <identifier: required> <replacement-list: optional> | (1)     |       |

**NOTE: You can find other versions within the reference material.**
## Explanation and Examples
### Version 1

The `#define` directives define the identifier as a macro, that is they instruct the compiler to replace all successive occurrences of identifier with replacement-list, which can be optionally additionally processed. If the identifier is already defined as any type of macro, the program is ill-formed unless the definitions are identical.

```C
#define ERROR_VALUE -1

int main()
{
	return ERROR_VALUE; // Returns -1
}
```

## Nice to know

### Include guards

Define directives are used to create include guards, these prevent multiple inclusions of a header file, which can happen if the file is included more than once in a program.

```C
#ifndef COLLATZ_CONJECTURE_H
#define COLLATZ_CONJECTURE_H

#define ERROR_VALUE -1

int steps(int start);

#endif
```

### Defining enums with the help of the define directive

```C
#ifndef RESISTOR_COLOR_DUO_H
#define RESISTOR_COLOR_DUO_H
#include <stdint.h>

//               0      1     2      3       4      5      6     7       8     9
#define COLORS BLACK, BROWN, RED, ORANGE, YELLOW, GREEN, BLUE, VIOLET, GREY, WHITE

typedef enum RESISTOR_BANDS { COLORS } resistor_band_t;

uint16_t color_code(resistor_band_t color[]);

#endif
```
