#ifndef _POSITIONER
#define _POSITIONER

#include <Servo.h>
#include "resultStorageHandler.h"

extern int servoStepActive;
extern bool debugPosition;
extern int servoOffsetAZ;
extern int servoOffsetEL;

void initPositioner();
void servo_move(PolarCoordinate position);

#endif
