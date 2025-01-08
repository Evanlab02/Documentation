# Robot Simulator

Write a robot simulator.

A robot factory's test facility needs a program to verify robot movements.

The robots have three possible movements:

- turn right
- turn left
- advance

Robots are placed on a hypothetical infinite grid, facing a particular direction (north, east, south, or west) at a set of {x,y} coordinates,
e.g., {3,8}, with coordinates increasing to the north and east.

The robot then receives a number of instructions, at which point the testing facility verifies the robot's new position, and in which direction it is pointing.

- The letter-string "RAALAL" means:
  - Turn right
  - Advance twice
  - Turn left
  - Advance once
  - Turn left yet again
- Say a robot starts at {7, 3} facing north.
  Then running this stream of instructions should leave it at {9, 4} facing west.

## Solution

```C
// robot_simulator.h
#ifndef ROBOT_SIMULATOR_H
#define ROBOT_SIMULATOR_H

typedef enum {
   DIRECTION_NORTH = 0,
   DIRECTION_DEFAULT = DIRECTION_NORTH,
   DIRECTION_EAST,
   DIRECTION_SOUTH,
   DIRECTION_WEST,
   DIRECTION_MAX
} robot_direction_t;

typedef struct {
   int x;
   int y;
} robot_position_t;

typedef struct {
   robot_direction_t direction;
   robot_position_t position;
} robot_status_t;

robot_status_t robot_create(robot_direction_t direction, int x, int y);
void robot_move(robot_status_t *robot, const char *commands);

#endif
```

```C
// robot_simulator.c
#include "robot_simulator.h"

robot_status_t robot_create(robot_direction_t direction, int x, int y)
{
    robot_position_t position;
    position.x = x;
    position.y = y;
	
    robot_status_t robot;
    robot.direction = direction;
    robot.position = position;
	
    return robot;
}

void robot_move(robot_status_t *robot, const char *commands)
{
    for (int i = 0; commands[i] != '\0'; i++)
    {
        if (commands[i] == 'R')
        {
            robot->direction++;
        }
		
        if (commands[i] == 'L')
        {
            if (robot->direction == DIRECTION_NORTH)
            {
                robot->direction = DIRECTION_WEST;
            }
            else
            {
                robot->direction--;
            }
        }
		
        if (robot->direction == DIRECTION_MAX)
        {
            robot->direction = DIRECTION_NORTH;
        }
		
        if (commands[i] == 'A')
        {
            int operation = robot->direction == DIRECTION_SOUTH || robot->direction == DIRECTION_WEST ? -1 : 1;
            if (robot->direction == DIRECTION_NORTH || robot->direction == DIRECTION_SOUTH)
            {
                robot->position.y += operation;
            }
            else
            {
                robot->position.x += operation;
            }
        }
    }
}
```
