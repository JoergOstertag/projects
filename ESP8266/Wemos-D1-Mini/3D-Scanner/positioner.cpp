#include "config.h"

#include "positioner.h"
#include <Arduino.h>


bool servoStepActive = true;
bool debugPosition = false;

PolarCoordinate servoLastPosition = {0, 0};

void delayServo(PolarCoordinate position);

#ifndef SERVO_PCA
#define SERVO_PWM
#endif


#ifdef SERVO_PCA
const uint8_t device_address = 0x40;

const size_t loop_delay = 100;

const uint8_t channelAz = 0;
const uint8_t channelEl = 1;

float servoAzRef1Grad  =   90;
float servoAzRef1Pulse = 2500;
float servoAzRef2Grad  =  -90;
float servoAzRef2Pulse =  550;

float servoElRef1Grad  =    0;
float servoElRef1Pulse =  610;
float servoElRef2Grad  = -180;
float servoElRef2Pulse = 2360;


#include <PCA9685.h>

PCA9685 pca9685;

uint16_t servo_pulse_duration;

void initPositioner() {
  pca9685.setupSingleDevice(Wire, device_address);
  pca9685.setToServoFrequency();

}

void pcaServoSet(PolarCoordinate position) {
  int servo_pulse_durationAz = map(position.az, servoAzRef1Grad, servoAzRef2Grad, servoAzRef1Pulse, servoAzRef2Pulse);
  int servo_pulse_durationEl = map(position.el, servoElRef1Grad, servoElRef2Grad, servoElRef1Pulse, servoElRef2Pulse);
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
#ifdef SERVO_PWM
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
