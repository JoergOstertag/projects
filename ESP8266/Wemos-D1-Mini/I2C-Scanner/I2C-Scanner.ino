
// --------------------------------------
// i2c_scanner
//
// Version 1
//    This program (or code that looks like it)
//    can be found in many places.
//    For example on the Arduino.cc forum.
//    The original author is not know.
// Version 2, Juni 2012, Using Arduino 1.0.1
//     Adapted to be as simple as possible by Arduino.cc user Krodal
// Version 3, Feb 26  2013
//    V3 by louarnold
// Version 4, March 3, 2013, Using Arduino 1.0.3
//    by Arduino.cc user Krodal.
//    Changes by louarnold removed.
//    Scanning addresses changed from 0...127 to 1...119,
//    according to the i2c scanner by Nick Gammon
//    http://www.gammon.com.au/forum/?id=10896
// Version 5, March 28, 2013
//    As version 4, but address scans now to 127.
//    A sensor seems to use address 120.
//
//
// This sketch tests the standard 7-bit addresses
// Devices with higher bit address might not be seen properly.
//

#include <Wire.h>

void setup()
{
  Wire.begin();
  Serial.begin(115200);

  Serial.println("\nI2C Scanner");
}


void loop()
{
  byte error, address;
  int nDevices;

  Serial.println("");
  Serial.println("------------------------------------------------------------");
  Serial.println("Scanning...");

  nDevices = 0;
  for (address = 1; address < 127; address++ )
  {
    // The i2c_scanner uses the return value of
    // the Write.endTransmisstion to see if
    // a device did acknowledge to the address.
    Wire.beginTransmission(address);
    error = Wire.endTransmission();

    if (error == 0)    {
      Serial.print("I2C device found at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.print(address, HEX);
      Serial.print(" :");

      switch (address) {
        case 0x29: Serial.println("\tLidar Sensor VL53L0X"); break;
        case 0x3C: Serial.println("\tOLED Display"); break;
        case 0x1E: Serial.println("\tHMC5883L"); break;
        case 0x77: Serial.println("\tBMP Sensor"); break;
        case 0x50: Serial.println("\tRTC DS1307"); break;
        case 0x68: Serial.println("\tRTC DS1307|GY-521"); break;
        case 0x48: Serial.println("\tPCF-8591 AD-Converter"); break;
        case 0x03: Serial.println("\tGrove LCD RGB"); break;
        case 0x62: Serial.println("\tGrove LCD RGB|Garmin Lidar Lite-V3"); break;
        case 0x70: Serial.println("\tGrove LCD RGB"); break;
        default:   Serial.println("");           break;
      };

      nDevices++;
    } else if (error == 4)    {
      Serial.print("Unknow error at address 0x");
      if (address < 16)
        Serial.print("0");
      Serial.println(address, HEX);
    }
  }
  if (nDevices == 0)
    Serial.println("No I2C devices found\n");
  else
    Serial.println("I2C scanning done\n");

  delay(2000);           // wait 5 seconds for next scan
}
