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

PolarCoordinate servoLastPosition = {0, 0};

void delayServo(PolarCoordinate position);


#ifdef SERVO_PCA
const uint8_t device_address = 0x40;

const size_t loop_delay = 100;

const uint8_t channelAz = 0;
const uint8_t channelEl = 1;

const uint16_t servoAzPulse_0 = 2360;
const uint16_t servoAzPulse_180 = 610;
const uint16_t servoElPulse_0 = 610;
const uint16_t servoElPulse_180 = 2360;


#include <PCA9685.h>

PCA9685 pca9685;

uint16_t servo_pulse_duration;

void initPositioner() {
  pca9685.setupSingleDevice(Wire, device_address);
  pca9685.setToServoFrequency();

}


void pcaServoSet(PolarCoordinate position) {
  int servo_pulse_durationAz = map(position.az, 0, 180, servoAzPulse_0, servoAzPulse_180);
  int servo_pulse_durationEl = map(position.el, 0, 180, servoElPulse_0, servoElPulse_180);
  if ( debugPosition) {
    Serial.printf( " AzPulse: %4d", (int)servo_pulse_durationAz );
    Serial.printf( " ElPulse: %4d", (int)servo_pulse_durationAz );
  }
  pca9685.setChannelServoPulseDuration(channelAz, servo_pulse_durationAz);
  pca9685.setChannelServoPulseDuration(channelEl, servo_pulse_durationEl);
  delay(loop_delay );
}
#endif


// ------------------------------------------------------
// PWM
// ------------------------------------------------------
#ifndef SERVO_PCA
Servo servo_az;
Servo servo_el;

void pwmServoSet(PolarCoordinate position) {
  servo_el.write(position.el);
  servo_az.write(position.az );
}

void initPositioner() {
  Serial.println("Attaching Servo ...");
  servo_az.attach(PIN_SERVO_AZ);  // attaches the servo
  servo_el.attach(PIN_SERVO_EL);  // attaches the servo
}
#endif


void delayServo(PolarCoordinate position) {

  int maxDifference = 0;

  maxDifference = max(maxDifference , abs(servoLastPosition.el - position.el));
  maxDifference = max(maxDifference , abs(servoLastPosition.az - position.az));

  if ( false ) {
    Serial.print(  " maxDifference: " );
    Serial.print(  maxDifference );
  }
  delay(1000 * maxDifference / 180);
}
/**
    -----------------------------------------------------------------
  TODO: remove parameter ResultStorageHandler resultStorageHandler
*/
void servo_move(PolarCoordinate position) {
  if (servoStepActive <= 0) {
    return;
  }

#ifdef SERVO_PCA
  pcaServoSet(position);
#else
  pwmServoSet(position);
#endif

  if ( debugPosition) {
    Serial.printf( " AzValue: %4d", (int)position.az );
    Serial.printf( " ElValue: %4d", (int)position.el );
  }

  delayServo(position);

  servoLastPosition = position;
}
