#include "positioner.h"

#define PIN_SERVO_AZ D8
#define PIN_SERVO_EL D7

int servoStepActive = 1;
boolean debugPosition = true;

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

  if ( debugPosition) {
    Serial.printf( " AZ: %4d", (int)position.az );
    Serial.printf( " EL: %4d", (int)position.el );
  }
  servo_el.write(position.el );
  servo_az.write(position.az );
  delay(30);
}
