# Luhn

## Instructions

Given a number determine whether or not it is valid per the Luhn formula.

The [Luhn algorithm][luhn] is a simple checksum formula used to validate a variety of identification numbers, such as credit card numbers and Canadian Social Insurance Numbers.

The task is to check if a given string is valid.

## Validating a Number

Strings of length 1 or less are not valid.
Spaces are allowed in the input, but they should be stripped before checking.
All other non-digit characters are disallowed.

### Example 1: valid credit card number

```text
4539 3195 0343 6467
```

The first step of the Luhn algorithm is to double every second digit, starting from the right.
We will be doubling

```text
4539 3195 0343 6467
↑ ↑  ↑ ↑  ↑ ↑  ↑ ↑  (double these)
```

If doubling the number results in a number greater than 9 then subtract 9 from the product.
The results of our doubling:

```text
8569 6195 0383 3437
```

Then sum all of the digits:

```text
8+5+6+9+6+1+9+5+0+3+8+3+3+4+3+7 = 80
```

If the sum is evenly divisible by 10, then the number is valid.
This number is valid!

### Example 2: invalid credit card number

```text
8273 1232 7352 0569
```

Double the second digits, starting from the right

```text
7253 2262 5312 0539
```

Sum the digits

```text
7+2+5+3+2+2+6+2+5+3+1+2+0+5+3+9 = 57
```

57 is not evenly divisible by 10, so this number is not valid.

### Based on

The Luhn Algorithm on Wikipedia - https://en.wikipedia.org/wiki/Luhn_algorithm

## Solution

```C
// luhn.h
#ifndef LUHN_H
#define LUHN_H

#include <stdbool.h>
#include <ctype.h>
#include <string.h>

int char_to_int(char num);

bool is_valid_luhn_number(char num);

bool luhn(const char *num);

#endif
```

```c
// luhn.c
#include "luhn.h"

int char_to_int(char num)
{
    return num - '0';
}

bool is_valid_luhn_number(char num)
{
    return num >= '0' && num <= '9';
}

bool luhn(const char *num)
{
    // If length of value provided equal or less than 1, it is invalid.
    int len_of_id = strlen(num);
    if (len_of_id <= 1)
    {
        return false;
    }

    // Total of the luhn algorithm, value should be divisible by 10 to be valid.
    int total = 0;

    // Which character we are on from the end of the string.
    int counter = 0;

    // Number of spaces
    int num_spaces = 0;

    // Loop from end of string to start of string.
    for (int index = len_of_id - 1; index >= 0; index--)
    {
        char value = num[index];

        // Ignore spaces
        if (value == ' ')
        {
            num_spaces += 1;
            continue;
        }

        // Validate value is valid number
        if (!is_valid_luhn_number(value))
        {
            return false;
        }

        // Determine how much we need to plus to total based on location in string.
        int increment = char_to_int(value);
        if (counter % 2 == 1)
        {
            increment = increment * 2;
            increment = increment > 9 ? increment - 9 : increment;
        }

        // Increment counter and adjust total
        counter += 1;
        total += increment;
    }

    // Invalid ID with spaces.
    if ((len_of_id - num_spaces) <= 1)
    {
        return false;
    }

    // Is valid luhn?
    return total % 10 == 0;
}
```