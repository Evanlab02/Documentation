# Triangle

## Instructions

Determine if a triangle is equilateral, isosceles, or scalene.

An _equilateral_ triangle has all three sides the same length.

An _isosceles_ triangle has at least two sides the same length.
(It is sometimes specified as having exactly two sides the same length, but for the purposes of this exercise we'll say at least two.)

A _scalene_ triangle has all sides of different lengths.

## Note

For a shape to be a triangle at all, all sides have to be of length > 0, and the sum of the lengths of any two sides must be greater than or equal to the length of the third side.

In equations:

Let `a`, `b`, and `c` be sides of the triangle.
Then all three of the following expressions must be true:

```text
a + b ≥ c
b + c ≥ a
a + c ≥ b
```

See [Triangle Inequality][triangle-inequality]

[triangle-inequality]: https://en.wikipedia.org/wiki/Triangle_inequality

## Solution

```c
// triangle.h
#ifndef TRIANGLE_H
#define TRIANGLE_H

#include <stdbool.h>

typedef struct
{
   double a;
   double b;
   double c;
} triangle_t;

bool is_triangle(triangle_t triangle);

bool is_equilateral(triangle_t triangle);

bool is_isosceles(triangle_t triangle);

bool is_scalene(triangle_t triangle);

#endif
```

```c
// triangle.c
#include "triangle.h"

bool is_triangle(triangle_t triangle)
{
    bool valid_a_side = triangle.a > 0 && triangle.a <= (triangle.b + triangle.c);
    bool valid_b_side = triangle.b > 0 && triangle.b <= (triangle.a + triangle.c);
    bool valid_c_side = triangle.c > 0 && triangle.c <= (triangle.a + triangle.b);
	
    return valid_a_side && valid_b_side && valid_c_side;
}

bool is_equilateral(triangle_t triangle)
{
    if (!is_triangle(triangle))
    {
        return false;
    }
	
    return triangle.a == triangle.b && triangle.a == triangle.c;
}

bool is_isosceles(triangle_t triangle)
{
    if (!is_triangle(triangle))
    {
        return false;
    }
	
    return triangle.a == triangle.b || triangle.a == triangle.c || triangle.b == triangle.c;
}

bool is_scalene(triangle_t triangle)
{
    if (!is_triangle(triangle))
    {
        return false;
    }
	
    return triangle.a != triangle.b && triangle.a != triangle.c && triangle.b != triangle.c;
}
```