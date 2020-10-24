#ifndef _POSITIONER
#define _POSITIONER

#include <Servo.h>
#include "resultStorageHandler.h"

extern bool servoStepActive;

extern bool debugPosition;


extern float servoAzRef1Grad;
extern float servoAzRef1Pulse;
extern float servoAzRef2Grad;
extern float servoAzRef2Pulse;

extern float servoElRef1Grad;
extern float servoElRef1Pulse;
extern float servoElRef2Grad;
extern float servoElRef2Pulse;

void initPositioner();
void servo_move(PolarCoordinate position);

#endif
