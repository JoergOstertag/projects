// #include <Arduino.h>

/**
   Naming of Pin D0 ==> 16
   Naming of Pin D1 ==> 5  // Wemos Relay Shield
   Naming of Pin D2 ==> 4
   Naming of Pin D3 ==> 0  // Button Shield
   Naming of Pin D4 ==> 2  // Default SDA if Wire.h
   Naming of Pin D5 ==> 14 // Default SCL of Wire.h; Default SCLK of SPI
   Naming of Pin D6 ==> 12 // Default MISO of SPI
   Naming of Pin D7 ==> 13 // Default MOSI of SPI
   Naming of Pin D8 ==> 15 // Default CS of SPI

  a) GPIO15 (D8) - high state makes go go to sdio mode (sd card boot mode)
  b) GPIO15 (D8) - low, GPIO0 (D3) - low, GPIO2(D4) - high = UART download mode
  c) GPIO15 (D8) - low, GPIO0 (D3)- high, GPIO2(D4) - high = boot from SPI
*/

int espPins[]     = {  D0, D1, D2, D3, D4, D5, D6, D7, D8};
String espPinNames[] = { "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8"};
int numOfPins = sizeof(espPins) / sizeof(int);

long loopCount = 0;

char data[100]; // for sprintf

/**
   Set All pins (Except D1) to input
*/
void setupAsInput() {
  Serial.print("Number of Pins: ");
  Serial.println(numOfPins);

  for (int i = 0; i < numOfPins; i++ ) {
    // pinMode(espPins[i], INPUT_PULLUP);

    pinMode(espPins[i], INPUT);
  }
}

/**
 * returns a header String lokking like:
 * D0     D1     D2     D3     D4     D5     D6     D7     D8          Named Pin Dx
 * GPIO16 GPIO5  GPIO4  GPIO0  GPIO2  GPIO14 GPIO12 GPIO13 GPIO15      Pin Number GPIOx
 *
 */
String headerString() {
  String result = "\n";
  for (int i = 0; i < numOfPins; i++ ) {
    result +=  espPinNames[i];
    result +=  "     ";
  }

  result += "     Named Pin Dx\n";
  for (int i = 0; i < numOfPins; i++ ) {
    sprintf(data, "GPIO%-2i ", espPins[i]);
    result += data;
  }
  result += "     Pin Number GPIOx\n";

  return result;
}


/**
    Read all defined Pins and return result as String
   Every 10 Lines Add Headers
*/
String readAllPins() {
  String result = "";

  // Add values of each Pin
  for (int i = 0; i < numOfPins; i++ ) {
    sprintf(data, "%-1i      ", digitalRead(espPins[i]));
    result += data;
  }

  return result;

}


void setup() {
  Serial.begin(115200);
  Serial.println("\n");
  Serial.println("Read All Digital Inputs");

  headerString();

  setupAsInput();
}

void loop() {

   // insert Header about Pin Numbers
  if ( !(loopCount++ % 10) ) {
    Serial.println(headerString());
  }
  
  Serial.println(readAllPins());
  delay(500);
}
