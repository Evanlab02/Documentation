[Issue](https://github.com/Evanlab02/Learning-C/issues/14)

# Multidimensional Arrays

In the previous tutorials on [Arrays](https://www.learn-c.org/en/Arrays), we covered, well, arrays and how they work. The arrays we looked at were all one-dimensional, but C can create and use multi-dimensional arrays. Here is the general form of a multidimensional array declaration:

```c
type name[size1][size2]...[sizeN];
```

For example, here's a basic one for you to look at -

```c
int foo[1][2][3];
```

or maybe this one -

```c
char vowels[1][5] = {
    {'a', 'e', 'i', 'o', 'u'}
};
```

### Two-dimensional Arrays

The simplest form of multidimensional array is the two-dimensional array. A two-dimensional array is pretty much a list of one-dimensional arrays. To declare a two-dimensional integer array of size [x] and [y], you would write something like this −

```c
type arrayName [x][y];
```

Where **type** can be any C data type (int, char, long, long long, double, etc.) and **arrayName** will be a valid C identifier, or variable. A two-dimensional array can be considered as a table which will have [ x ] number of rows and [ y ] number of columns. A two-dimensional array a, which contains three rows and four columns can be shown and thought about like this −

![Table 1A](https://www.tutorialspoint.com/cprogramming/images/two_dimensional_arrays.jpg)

In this sense, every element in the array a is identified by an element name in the form **a\[i]\[j]**, where 'a' is the name of the array, and 'i' and 'j' are the indexes that uniquely identify, or show, each element in 'a'.

And honestly, you really don't have to put in a [ x ] value really, because if you did something like this -

```c
char vowels[][5] = {
    {'A', 'E', 'I', 'O', 'U'},
    {'a', 'e', 'i', 'o', 'u'}
};
```

the compiler would already know that there are two "dimensions" you could say, but, you NEED a [ y ] value!! The compiler may be smart, but it _will not know_ how many integers, characters, floats, whatever you're using you have in the dimensions. Keep that in mind.

### Initialising Two-Dimensional Arrays

Multidimensional arrays may be used by specifying bracketed[] values for each row. Below is an array with 3 rows and each row has 4 columns. To make it easier, you can forget the 3 and keep it blank, it'll still work.

```c
int a[3][4] = {  
   {0, 1, 2, 3} ,   /*  initializers for row indexed by 0 */
   {4, 5, 6, 7} ,   /*  initializers for row indexed by 1 */
   {8, 9, 10, 11}   /*  initializers for row indexed by 2 */
};
```

The inside braces, which indicates the wanted row, are optional. The following initialisation is the same to the previous example −

```c
int a[3][4] = {0,1,2,3,4,5,6,7,8,9,10,11};
```

### Accessing Two-Dimensional Array Elements

An element in a two-dimensional array is accessed by using the subscripts, i.e., row index and column index of the array. For example −

```c
int val = a[2][3];
```

The above statement will take the 4th element from the 3rd row of the array.

## Exercise

Let us try to find out the average marks of a group of five students for two subjects, Mathematics and Physics. To do this, we use a two-dimensional array called `grades`. The marks corresponding to Mathematics would be stored in the first row (`grades[0]`), whereas those corresponding to Physics would be stored in the second row (`grades[1]`). Complete the following steps so that you can execute this program.

- Declare grades as a two-dimensional array of integers
- Complete the for loops by specifying their terminating conditions
- Compute the average marks obtained in each subject

### Provided code

```C
#include <stdio.h>

int main() {
	/* TODO: declare the 2D array grades here */
	float average;
	int i;
	int j;
	
	grades[0][0] = 80;
	grades[0][1] = 70;
	grades[0][2] = 65;
	grades[0][3] = 89;
	grades[0][4] = 90;
	
	grades[1][0] = 85;
	grades[1][1] = 80;
	grades[1][2] = 80;
	grades[1][3] = 82;
	grades[1][4] = 87;
	
	/* TODO: complete the for loop with appropriate terminating conditions */
	for (i = 0; i < ; i++) {
		average = 0;
		for (j = 0; j < ; j++) {
			average += grades[i][j];
		}
	
		/* TODO: compute the average marks for subject i */
		printf("The average marks obtained in subject %d is: %.2f\n", i, average);
	}
	
	return 0;
}
```

### Solution code

```C
#include <stdio.h>

int main() {
  // 2D array to store the grades of five students in two subjects.
  int grades[2][5];

  // Table representation of the grades array if populated:
  // Student | Subject 1 | Subject 2
  // --------------------------------
  // 1       | 80        | 85
  // 2       | 70        | 80
  // 3       | 65        | 80
  // 4       | 89        | 82
  // 5       | 90        | 87

  // Other variables
  float average;
  int i;
  int j;

  // Populate the grades array for subject 1.
  grades[0][0] = 80;
  grades[0][1] = 70;
  grades[0][2] = 65;
  grades[0][3] = 89;
  grades[0][4] = 90;

  // Populate the grades array for subject 2.
  grades[1][0] = 85;
  grades[1][1] = 80;
  grades[1][2] = 80;
  grades[1][3] = 82;
  grades[1][4] = 87;

  // Loop [0, 1]
  for (i = 0; i < 2; i++) {
    average = 0;

    // Loop [0, 1, 2, 3, 4]
    for (j = 0; j < 5; j++) {
      average += grades[i][j];
    }

    // Calculate average
    average = average / 5;
    printf("The average marks obtained in subject %d is: %.2f\n", i, average);
  }

  return 0;
}
```
