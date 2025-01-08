# Conditional inclusion

Reference: [devdocs.io](https://devdocs.io/c/preprocessor/conditional)

The preprocessor supports conditional compilation of parts of source file. This behaviour is controlled by `#if`, `#else`, `#elif`, `#ifdef`, `#ifndef`, `#elifdef`, `#elifndef`(since C23), and `#endif` directives.

## Syntax

| `#if` expression       |     |             |
| ---------------------- | --- | ----------- |
| `#ifdef` identifier    |     |             |
| `#ifndef` identifier   |     |             |
| `#elif` expression     |     |             |
| `#elifdef` identifier  |     | (since C23) |
| `#elifndef` identifier |     | (since C23) |
| `#else`                |     |             |
| `#endif`               |     |             |

## Explanation

The conditional pre-processing block starts with `#if`, `#ifdef` or `#ifndef` directive, then optionally includes any number of `#elif`, `#elifdef`, or `#elifndef`(since C23) directives, then optionally includes at most one `#else` directive and is terminated with `#endif` directive. Any inner conditional pre-processing blocks are processed separately.

Each of `#if`, `#ifdef`, `#ifndef`, `#elif`, `#elifdef`, `#elifndef`(since C23), and `#else` directives control code block until first `#elif`, `#elifdef`, `#elifndef`(since C23), `#else`, `#endif` directive not belonging to any inner conditional pre-processing blocks.

`#if`, `#ifdef` and `#ifndef` directives test the specified condition (see below) and if it evaluates to true, compiles the controlled code block. In that case subsequent `#else`, `#elifdef`, `#elifndef`,(since C23) and `#elif` directives are ignored. Otherwise, if the specified condition evaluates false, the controlled code block is skipped and the subsequent `#else`, `#elifdef`, `#elifndef`,(since C23) or `#elif` directive (if any) is processed. If the subsequent directive is `#else`, the code block controlled by the `#else` directive is unconditionally compiled. Otherwise, the `#elif`, `#elifdef`, or `#elifndef`(since C23) directive acts as if it was `#if` directive: checks for condition, compiles or skips the controlled code block based on the result, and in the latter case processes subsequent `#elif`, `#elifdef`, `#elifndef`,(since C23) and `#else` directives. The conditional pre-processing block is terminated by `#endif` directive.

## Example

```c
#define ABCD 2
#include <stdio.h>
 
int main(void)
{
 
#ifdef ABCD
    printf("1: yes\n");
#else
    printf("1: no\n");
#endif
 
#ifndef ABCD
    printf("2: no1\n");
#elif ABCD == 2
    printf("2: yes\n");
#else
    printf("2: no2\n");
#endif
 
#if !defined(DCBA) && (ABCD < 2 * 4 - 3)
    printf("3: yes\n");
#endif
 
// C23 directives #elifdef/#elifndef
#ifdef CPU
    printf("4: no1\n");
#elifdef GPU
    printf("4: no2\n");
#elifndef RAM
    printf("4: yes\n"); // selected in C23 mode, may be selected in pre-C23 mode
#else
    printf("4: no3\n"); // may be selected in pre-C23 mode
#endif
}
```

## Nice to know

### Include guards

`#ifndef` is used to create include guards, these prevent multiple inclusions of a header file, which can happen if the file is included more than once in a program.

```C
#ifndef COLLATZ_CONJECTURE_H
#define COLLATZ_CONJECTURE_H

#define ERROR_VALUE -1

int steps(int start);

#endif
```
