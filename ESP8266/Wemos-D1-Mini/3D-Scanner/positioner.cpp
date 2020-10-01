#include "config.h"

#include "positioner.h"
#include <Arduino.h>


int servoStepActive = 1;
boolean debugPosition = true;

// Correction for Servo Direction and Position
boolean servoCounterClockwiseAZ = true;
boolean servoCounterClockwiseEL = true;
int servoOffsetAZ = -90;
int servoOffsetEL = -90;



#ifdef SERVO_PCA

const uint8_t device_address = 0x40;

const size_t loop_delay = 100;

const uint8_t channelAz = 0;
const uint8_t channelEl = 1;

const uint16_t servo_pulse_duration_min = 900;
const uint16_t servo_pulse_duration_max = 2100;
const uint16_t servo_pulse_duration_increment = 100;


#include <PCA9685.h>

PCA9685 pca9685;

uint16_t servo_pulse_duration;

void initPositioner() {
  pca9685.setupSingleDevice(Wire, device_address);

  pca9685.setToServoFrequency();

  servo_pulse_duration = servo_pulse_duration_min;
}


void pwmServoSet(int azValue, int elValue) {
  //  pulselength = map(degrees, 0, 180, SERVOMIN, SERVOMAX);
  pca9685.setChannelServoPulseDuration(channelAz, servo_pulse_duration);
  pca9685.setChannelServoPulseDuration(channelEl, servo_pulse_duration);
}

#endif


// ------------------------------------------------------
// PWM
// ------------------------------------------------------
#ifndef SERVO_PCA


Servo servo_az;
Servo servo_el;

void pwmServoSet(int azValue, int elValue) {


  servo_el.write(elValue);
  servo_az.write(azValue );

  delayServo( azValue, elValue);
}

void delayServo(int azValue, int elValue) {

  int maxDifference = 0;

  maxDifference = max(maxDifference , abs(servo_el.read() - elValue));
  maxDifference = max(maxDifference , abs(servo_az.read() - azValue));

  if ( false ) {
    Serial.print(  " maxDifference: " );
    Serial.print(  maxDifference );
  }
  delay(1000 * maxDifference / 180);
}


void initPositioner() {
  Serial.println("Attaching Servo ...");
  servo_az.attach(PIN_SERVO_AZ);  // attaches the servo
  servo_el.attach(PIN_SERVO_EL);  // attaches the servo
}

#endif


/**
    -----------------------------------------------------------------
  TODO: remove parameter ResultStorageHandler resultStorageHandler
*/
void servo_move(PolarCoordinate position) {
  if (servoStepActive <= 0) {
    return;
  }


  int elValue = (servoCounterClockwiseEL ? 180 - position.el : position.el) + servoOffsetEL;
  int azValue = (servoCounterClockwiseAZ ? 180 - position.az : position.az) + servoOffsetAZ;

#ifdef SERVO_PCA

  pcaServoSet(azValue, elValue);
#else
  pwmServoSet(azValue, elValue);
#endif
  if ( debugPosition) {
    Serial.printf( " AzValue: %4d", (int)azValue );
    Serial.printf( " ElValue: %4d", (int)elValue );
  }


}
