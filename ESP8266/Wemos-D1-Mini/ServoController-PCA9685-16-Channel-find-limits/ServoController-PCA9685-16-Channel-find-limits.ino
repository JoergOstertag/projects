#include <Arduino.h>
#include <PCA9685.h>

#include "Constants.h"

//#define OUTPUT_ENABLE_PIN

PCA9685 pca9685;

uint16_t servo_pulse_duration = 1500; // 150ms is about middle

uint8_t channel = 0;
const uint8_t device_address = 0x40;
const size_t output_enable_pin = 2;

const size_t loop_delay = 1000;

void setup()
{

  Serial.begin(115200);

  Serial.println();
  Serial.println("Enter integers");
  Serial.println("1 - 17 == switch to channel 0 .. 16");
  Serial.println("18 ...     set value of pulse duration");


  pca9685.setupSingleDevice(Wire, device_address);

#ifdef OUTPUT_ENABLE_PIN
  pca9685.setupOutputEnablePin(output_enable_pin);
  pca9685.enableOutputs(output_enable_pin);
#endif

  pca9685.setToServoFrequency();

}

void loop() {

  int input = Serial.parseInt() ;
  if ( input == 0 ) {
  } else if ( input < 17) {
    channel = input - 1;
  } else {
    servo_pulse_duration = input;
  }

  if (input > 0) {
    Serial.print("channel: ");
    Serial.print(channel);
    Serial.print(" servo_pulse_duration: ");
    Serial.print(servo_pulse_duration);
    Serial.println();
  }

  if (servo_pulse_duration > 0) {
    pca9685.setChannelServoPulseDuration(channel , servo_pulse_duration);
  }

  delay(loop_delay);
}
