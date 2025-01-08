# Common Imports

- Booleans:  `#include <stdbool.h>`
- Integers:  `#include <stdint.h>`
- Input/Output: `#include <stdio.h>`
- Strings: `#include <string.h>`
- Standard Lib: `#include <stdlib.h>`
# Integers

- `unsigned int`: Number that does not allow negatives.
- `int`: Number that does allow negatives.
- `uint64_t`: Signed integers with different size variations (8, 16, 32, 64) (Requires: `<stdint.h>`)
# Header Files

You will usually have two files when creating a C project, your C source files  (`hello_world.c`) and its corresponding header file (`hello_world.h`). 
You will need to import your header file in your C file like so: `#include "hello_world.h"`.
## Difference between file imports and lib imports

Lib: `#include <stdbool.h>`
File: `#include "hello_world.h"`
## Include Guards

Include guards ensures that the header is only included once.

Example:

```c
#ifndef HELLO_WORLD_H
#define HELLO_WORLD_H

const char *hello(void);

#endif
```

If you file is named `hello_world.h` it seems it is required/best practice to define the include guard as `#ifndef HELLO_WORLD_H`.

## Defining values

You can also define values within header files like so:

```C
#define ERROR_VALUE -1
```
# Enums

Usually defined within header files:

```C
typedef enum {
    BLACK = 0,
    BROWN = 1,
    RED = 2,
    ORANGE = 3,
    YELLOW = 4,
    GREEN = 5,
    BLUE = 6,
    VIOLET = 7,
    GREY = 8,
    WHITE = 9
} resistor_band_t;
```

Could also be defined like:

```c
#define COLORS BLACK, BROWN, RED, ORANGE, YELLOW, GREEN, BLUE, VIOLET, GREY, WHITE

typedef enum RESISTOR_BANDS { COLORS } resistor_band_t;
```


# Pointers

## String pointers:

```C
char * name = "John";
```
## Dereferencing:

```C
int a = 1;
int * pointer_to_a = &a;

/* let's change the variable a */
a += 1;

/* we just changed the variable again! */
*pointer_to_a += 1;

/* will print out 3 */
printf("The value of a is now %d\n", a);
```

## Function arguments by reference

```C
void addone(int *n) {
    // n is a pointer here which point to a memory-adress outside the function scope
    (*n)++; // this will effectively increment the value of n
}

int n;
printf("Before: %d\n", n);
addone(&n);
printf("After: %d\n", n);
```
# Structures

```C
struct point {
    int x;
    int y;
};

/* draws a point at 10, 5 */
struct point p;
p.x = 10;
p.y = 5;
draw(p);
```
## Typedefs

```C
typedef struct {
    int x;
    int y;
} point;

point p;
```
## Pointers in structures

```C
typedef struct {
    char * brand;
    int model;
} vehicle;

vehicle mycar;
mycar.brand = "Ford";
mycar.model = 2007;
```

# Dynamic Allocation

```C
typedef struct {
    char * name;
    int age;
} person;

person * myperson = (person *) malloc(sizeof(person)); // Memory allocation

myperson->name = "John";
myperson->age = 27;

free(myperson); // Free the memory
```

## Dynamic Allocation for arrays

```C
int nrows = 2;
int ncols = 5;
int i, j;

// Allocate memory for nrows pointers
char **pvowels = (char **) malloc(nrows * sizeof(char *));

// For each row, allocate memory for ncols elements
pvowels[0] = (char *) malloc(ncols * sizeof(char));
pvowels[1] = (char *) malloc(ncols * sizeof(char));

pvowels[0][0] = 'A';
pvowels[0][1] = 'E';
pvowels[0][2] = 'I';
pvowels[0][3] = 'O';
pvowels[0][4] = 'U';

pvowels[1][0] = 'a';
pvowels[1][1] = 'e';
pvowels[1][2] = 'i';
pvowels[1][3] = 'o';
pvowels[1][4] = 'u';

for (i = 0; i < nrows; i++) {
    for(j = 0; j < ncols; j++) {
        printf("%c ", pvowels[i][j]);
    }

    printf("\n");
}

// Free individual rows
free(pvowels[0]);
free(pvowels[1]);

// Free the top-level pointer
free(pvowels);
```

