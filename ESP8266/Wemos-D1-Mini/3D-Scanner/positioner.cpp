#include "config.h"

#include "positioner.h"
#include <Arduino.h>

#include <PCA9685.h>

// #include <ESP8266WiFi.h>
// #include <WiFiClient.h>
// #include <ESP8266WebServer.h>



#ifndef SERVO_PCA
#define SERVO_PWM
#endif


bool servoStepActive = true;
bool debugPosition = false;

PolarCoordinate servoLastPosition = {0, 0};

void delayServo(PolarCoordinate position);


// For SERVO_PCA
PCA9685 pca9685;
const uint8_t device_address = 0x40;

const size_t loop_delay = 100;

const uint8_t channelAz = 0;
const uint8_t channelEl = 1;

// These Values are set in setPulseReferences()
float servoAzRef1Grad  =   90;
float servoAzRef1Pulse = 2220;
float servoAzRef2Grad  =  -90;
float servoAzRef2Pulse =  900;

float servoElRef1Grad  =  180;
float servoElRef1Pulse =  900;
float servoElRef2Grad  =    0;
float servoElRef2Pulse = 2200;



uint16_t servo_pulse_duration;

void initPositionerPCA() {
  Serial.println(F("Initialize PCA8685 ..."));
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


// ------------------------------------------------------
// PWM
// ------------------------------------------------------
Servo servo_az;
Servo servo_el;

void pwmServoSet(PolarCoordinate position) {
  servo_el.write(position.el);
  servo_az.write(position.az );
}


void initPositionerPWM() {
  Serial.println(F("Initialize Normal PWM Servos ..."));
  Serial.println("Attaching Servo ...");

  Serial.print(F("AZ-Servo to Pin ")); Serial.print(PIN_SERVO_AZ); Serial.println();
  servo_az.attach(PIN_SERVO_AZ);  // attaches the servo

  Serial.print(F("EL-Servo to Pin ")); Serial.print(PIN_SERVO_EL); Serial.println();
  servo_el.attach(PIN_SERVO_EL);  // attaches the servo
}


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


void setPulseReferences() {
  //  String chipId = String(ESP_getChipId(), HEX);
  //  Serial.print(F("chipId: "));  Serial.print(chipId);  Serial.println();

  if (0)  { // Scanner Thomas
    servoAzRef1Pulse = 2380;
    servoAzRef2Pulse =  750;
    servoElRef1Pulse =  555;
    servoElRef2Pulse = 2300;
  }

  // Scanner Joerg
  if (1) {
    servoAzRef1Pulse = 2200;
    servoAzRef2Pulse =  560;
    servoElRef1Pulse =  470;
    servoElRef2Pulse = 2450;
  }
}

void initPositioner() {

  setPulseReferences();
  
#ifdef SERVO_PCA
  initPositionerPCA();
#else
  initPositionerPWM();
#endif

}
