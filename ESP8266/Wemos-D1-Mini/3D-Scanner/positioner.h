#ifndef _POSITIONER
#define _POSITIONER

#include <Servo.h>
#include "resultStorageHandler.h"

extern bool servoStepActive;

extern bool debugPosition;

void initPositioner();
void servo_move(PolarCoordinate position);

#endif
