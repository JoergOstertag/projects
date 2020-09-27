#include "positioner.h"

#define PIN_SERVO_AZ D8
#define PIN_SERVO_EL D7

int servoStepActive = 1;
boolean debugPosition = true;

// Correction for Servo Direction and Position
boolean servoCounterClockwiseAZ = true;
boolean servoCounterClockwiseEL = true;
int servoOffsetAZ = -90;
int servoOffsetEL = -90;

Servo servo_az;
Servo servo_el;

void initPositioner() {
  Serial.println("Attaching Servo ...");
  servo_az.attach(PIN_SERVO_AZ);  // attaches the servo
  servo_el.attach(PIN_SERVO_EL);  // attaches the servo
}

/**
  TODO: remove parameter ResultStorageHandler resultStorageHandler
*/
void servo_move(PolarCoordinate position) {
  if (servoStepActive <= 0) {
    return;
  }


  int maxDifference = 0;

  int elValue = (servoCounterClockwiseEL ? 180 - position.el : position.el) + servoOffsetEL;
  maxDifference = max(maxDifference , abs(servo_el.read() - elValue));
  servo_el.write(elValue);


  int azValue = (servoCounterClockwiseAZ ? 180 - position.az : position.az) + servoOffsetAZ;
  maxDifference = max(maxDifference , abs(servo_az.read() - azValue));
  servo_az.write(azValue );

  if ( debugPosition) {
    Serial.printf( " AzValue: %4d", (int)azValue );
    Serial.printf( " ElValue: %4d", (int)elValue );
  }


  if ( false ) {
    Serial.print(  " maxDifference: " );
    Serial.print(  maxDifference );
  }
  delay(1000 * maxDifference / 180);
}
