[Issue](https://github.com/Evanlab02/Learning-C/issues/14)
# Arrays

Arrays are special variables which can hold more than one value under the same variable name, organised with an index. Arrays are defined using a very straightforward syntax:

```c
/* defines an array of 10 integers */
int numbers[10];
```

Accessing a number from the array is done using the same syntax. Notice that arrays in C are zero-based, which means that if we defined an array of size 10, then the array cells 0 through 9 (inclusive) are defined. `numbers[10]` is not an actual value.

```c
int numbers[10];

/* populate the array */
numbers[0] = 10;
numbers[1] = 20;
numbers[2] = 30;
numbers[3] = 40;
numbers[4] = 50;
numbers[5] = 60;
numbers[6] = 70;

/* print the 7th number from the array, which has an index of 6 */
printf("The 7th number in the array is %d", numbers[6]);
```

Arrays can only have one type of variable, because they are implemented as a sequence of values in the computer's memory. Because of that, accessing a specific array cell is very efficient.

## Exercise

- The code below does not compile, because the `grades` variable is missing.
- One of the grades is missing. Can you define it so the grade average will be 85?

### Provided code

```C
#include <stdio.h>

int main() {
  /* TODO: define the grades variable here */
  int average;

  grades[0] = 80;
  /* TODO: define the missing grade so that the average will sum to 85. */
  grades[2] = 90;

  average = (grades[0] + grades[1] + grades[2]) / 3;
  printf("The average of the 3 grades is: %d", average);

  return 0;
}
```

### Solution code

```C
#include <stdio.h>

int main() {
  // When declaring arrays, need to specify the size of the array.
  int grades[3];

  // Due to no size being specified, this will just be an integer.
  int average;

  // Populate array indices with grades.
  grades[0] = 80;
  grades[1] = 85;
  grades[2] = 90;

  // Some calculation and display.
  average = (grades[0] + grades[1] + grades[2]) / 3;
  printf("The average of the 3 grades is: %d\n", average);

  return 0;
}
```
