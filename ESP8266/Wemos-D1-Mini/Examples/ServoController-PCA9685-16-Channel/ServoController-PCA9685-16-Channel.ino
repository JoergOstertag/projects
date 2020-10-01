#include <Arduino.h>
#include <PCA9685.h>

#include "Constants.h"


PCA9685 pca9685;

uint16_t servo_pulse_duration;

void setup()
{

  Serial.begin(115200);

  Serial.println();

  pca9685.setupSingleDevice(Wire, constants::device_address);


  pca9685.setupOutputEnablePin(constants::output_enable_pin);
  pca9685.enableOutputs(constants::output_enable_pin);

  pca9685.setToServoFrequency();

  servo_pulse_duration = constants::servo_pulse_duration_min;
}

void loop() {
  if (servo_pulse_duration > constants::servo_pulse_duration_max) {
    servo_pulse_duration = constants::servo_pulse_duration_min;
    Serial.println();
  }

  pca9685.setChannelServoPulseDuration(constants::channel + 1, servo_pulse_duration);
  //  pca9685.setChannelServoPulseDuration(constants::channel + 2, servo_pulse_duration);
  Serial.print(servo_pulse_duration);

  Serial.println();
  servo_pulse_duration += constants::servo_pulse_duration_increment;

  delay(constants::loop_delay);
}
