// - - - - -
// ESPDMX - A Arduino library for sending and receiving DMX using the builtin serial hardware port.
//
// Copyright (C) 2015  Rick <ricardogg95@gmail.com> (edited by Marcel Seerig)
// This work is licensed under a GNU style license.
//
// Last change: Marcel Seerig <https://github.com/mseerig>
//
// Documentation and samples are available at https://github.com/Rickgg/ESP-Dmx
// - - - - -

/**
 * D4 is writing Output of Serial1
 * 
 * Reading can NOT be done, since the Library has no read support and the 8266 has no read Pin for Serial1
 * 
 */

#include <ESPDMX.h>

DMXESPSerial dmx;

void setup() {
  Serial.begin(115200);
  dmx.init(512);               // initialization
  delay(200);               // wait a while (not necessary)
}

int address;
void loop() {
  address=60;
  int value=0;
  dmx.write(address++ , value);
  dmx.write(address++ , value);
  dmx.write(address++ , value);
  dmx.write(address++ , value);
  dmx.write(address++ , value);

  dmx.update();             // update the DMX bus
  for ( int i = 60; i<=65; i++) {
    int data = dmx.read(i);   // data from channel 1
    Serial.print(data);
    Serial.print(" ");
  }
  Serial.println();     // print it out
  delay(.5*1000);
}
