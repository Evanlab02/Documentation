# Isograms

Determine if a word or phrase is an isogram.

An isogram (also known as a "non-pattern word") is a word or phrase without a repeating letter, however spaces and hyphens are allowed to appear multiple times.

Examples of isograms:

- lumberjacks
- background
- downstream
- six-year-old

The word *isograms*, however, is not an isogram, because the s repeats.

## Solution

```C
// isogram.h
#ifndef ISOGRAM_H
#define ISOGRAM_H

#include <stdbool.h>

bool is_isogram(const char phrase[]);

#endif
```

```C
// isogram.c
#include "isogram.h"

bool is_isogram(const char phrase[])
{
    // If phrase is null, it is not an isogram.
    if (!phrase)
    {
        return false;
    }
	
    // Result array confirming how much of each letter was found.
    int results[26] = {0};
	
    // Loop through each character in the phrase.
    for (int index = 0; phrase[index] != '\0'; index++)
    {
        // Get ascii value of character.
        int asciiValue = phrase[index];
		
        // If Uppercase, convert to lowercase.
        if (asciiValue >= 'A' && asciiValue <= 'Z')
        {
            asciiValue += 32;
        }
		
        // If within acceptable characters, add one to the index in the results matching the alphabet order.
        if (asciiValue >= 'a' && asciiValue <= 'z')
        {
            int result_position = asciiValue - 'a';
            results[result_position] += 1;
        }
    }
	
    // Check results
    for (int index = 0; index < 26; index++)
    {
        // If any value occurs more than once, it is not an isogram.
        if (results[index] != 0 && results[index] != 1)
        {
            return false;
        }
    }
	
    // If made this far, it is an isogram.
    return true;
}
```

