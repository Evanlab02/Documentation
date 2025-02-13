[Issue](https://github.com/Evanlab02/Learning-C/issues/14)

# Recursion

Recursion occurs when a function contains within it a call to itself. Recursion can result in very neat, elegant code that is intuitive to follow. It can also result in a very large amount of memory being used if the recursion gets too deep.

Common examples of where recursion is used :

- Walking recursive data structures such as linked lists, binary trees, etc.
- Exploring possible scenarios in games such as chess

Recursion always consists of two main parts. A terminating case that indicates when the recursion will finish and a call to itself that must make progress towards the terminating case.

For example, this function will perform multiplication by recursively adding :

```c
#include <stdio.h>

unsigned int multiply(unsigned int x, unsigned int y)
{
    if (x == 1)
    {
        /* Terminating case */
        return y;
    }
    else if (x > 1)
    {
        /* Recursive step */
        return y + multiply(x-1, y);
    }

    /* Catch scenario when x is zero */
    return 0;
}

int main() {
    printf("3 times 5 is %d", multiply(3, 5));
    return 0;
}
```

## Exercise

Define a new function called `factorial()` that will compute the factorial by recursive multiplication (5! = 5 x 4 x 3 x 2 x 1). Note that by convention, the factorial of 0 is equal to 1 (0! = 1).

### Provided code

```C
#include <stdio.h>

int main() {
    /* testing code */
    printf("0! = %i\n", factorial(0));
    printf("1! = %i\n", factorial(1));
    printf("3! = %i\n", factorial(3));
    printf("5! = %i\n", factorial(5));
}

/* define your function here (don't forget to declare it) */
```

### Solution code

```C
#include <stdio.h>

int factorial(int n);

int main() {
  /* testing code */
  printf("0! = %i\n", factorial(0));
  printf("1! = %i\n", factorial(1));
  printf("3! = %i\n", factorial(3));
  printf("5! = %i\n", factorial(5));
}

int factorial(int n) {
  if (n == 0) {
    return 1;
  } else {
    return n * factorial(n - 1);
  }
}
```
