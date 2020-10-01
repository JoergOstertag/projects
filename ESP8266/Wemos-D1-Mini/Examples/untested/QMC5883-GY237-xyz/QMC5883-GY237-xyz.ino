/*
  ===============================================================================================================
  QMC5883LCompass.h Library XYZ Example Sketch
  Learn more at [https://github.com/mprograms/QMC5883Compas]

  This example shows how to get the XYZ values from the sensor.

  extended by
    - showing values against reference at startup
    - Showing Azimut and bearing

  ===============================================================================================================
  Release under the GNU General Public License v3
  [https://www.gnu.org/licenses/gpl-3.0.en.html]
  ===============================================================================================================


  Used Board:
      GY-273 with Chip HMC5883L
  Connections for Wemos D1 Mini:
      VCC  O ---- O +5v
      GND  O ---- O GND
      SCL  O ---- O D1
      SDA  O ---- O D2
      DRDY O ---- X NOT CONNECTED

*/
#include <QMC5883LCompass.h>

QMC5883LCompass compass;

int x_0 = 0;
int y_0 = 0;
int z_0 = 0;
int a_0 = 0;
int b_0 = 0;

long count = 0L;

void initCompass() {
  compass.init();

  /**
    | MODE CONTROL (MODE)     | Value |
    | ----------------------- | ----- |
    | Standby             | 0x00  |
    | Continuous            | 0x01  |
  */
  byte set_mode = 0x01;

  /*
      | OUTPUT DATA RATE (ODR)  | Value |
      | ----------------------- | ----- |
      | 10Hz                  | 0x00  |
      | 50Hz                  | 0x04  |
      | 100Hz                 | 0x08  |
      | 200Hz                 | 0x0C  |
  */
  byte set_odr = 0x0c;

  /*
      | FULL SCALE (RNG)        | Value |
      | ----------------------- | ----- |
      | 2G                | 0x00  |
      | 8G                | 0x10  |
  */
  byte set_rng = 0x10;

  /*
      | OVER SAMPLE RATIO (OSR) | Value |
      | ----------------------- | ----- |
      | 64                | 0xC0  |
      | 128               | 0x80  |
      | 256               | 0x40  |
      | 512               | 0x00  |
  */
  byte set_osr = 0x00;

  compass.setMode(set_mode, set_odr, set_rng, set_osr);

  delay(100);

}

void compassSetStartingPoint() {

  compass.read();

  // Return XYZ readings
  x_0 = compass.getX();
  y_0 = compass.getY();
  z_0 = compass.getZ();
  a_0 = compass.getAzimuth();
  b_0 = compass.getBearing(a_0);

  printCompassInit();
}

void printCompassInit() {
  Serial.print("Reference Values .... ");
  Serial.print("X: ");        Serial.print(x_0);
  Serial.print(" Y: ");       Serial.print(y_0);
  Serial.print(" Z: ");       Serial.print(z_0);
  Serial.print(" Azimuth: "); Serial.print(a_0);
  Serial.print(" Bearing: "); Serial.print(b_0);
  Serial.println();

}

void setup() {
  Serial.begin(115200);
  Serial.println();

  initCompass();
  compassSetStartingPoint();
}

void loop() {
  int x, y, z, a, b;
  char myArray[3];


  // Show ref Values every 100th line
  count++;
  if ( (count % 100 ) == 0) {
    printCompassInit();
  }



  // Init Smoothing
  int steps = 10;
  boolean advanced = true;
  compass.setSmoothing(steps, advanced);

  // Read compass values
  compass.read();

  // Return XYZ readings
  x = compass.getX();
  y = compass.getY();
  z = compass.getZ();
  a = compass.getAzimuth();
  b = compass.getBearing(a);
  compass.getDirection(myArray, a);

  Serial.print(count);        Serial.print(": ");

  Serial.print("Raw: ");

  Serial.print("X: ");        Serial.print(x);
  Serial.print(" Y: ");       Serial.print(y);
  Serial.print(" Z: ");       Serial.print(z);
  Serial.print(" Azimuth: "); Serial.print(a);
  Serial.print(" Bearing: "); Serial.print(b);

  Serial.print(" Direction: ");
  Serial.print(myArray[0]);
  Serial.print(myArray[1]);
  Serial.print(myArray[2]);

  Serial.print("\tagainst 0-ref: ");
  Serial.print("X: ");        Serial.print(x - x_0);
  Serial.print(" Y: ");       Serial.print(y - y_0);
  Serial.print(" Z: ");       Serial.print(z - z_0);
  Serial.print(" Azimuth: "); Serial.print(a - a_0);
  Serial.print(" Bearing: "); Serial.print(b - b_0);

  Serial.println();

  delay(250);
}
