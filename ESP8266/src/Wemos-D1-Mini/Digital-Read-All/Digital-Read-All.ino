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
  
/**
 * Set All pins (Except D1) to input
 */
void setupAsInput() {
  Serial.print("Number of Pins: ");
  Serial.println(numOfPins);

  for (int i = 0; i < numOfPins; i++ ) {
    // pinMode(espPins[i], INPUT_PULLUP);

    // If we would set D1 to input nothing can be seen on console
    if ( i != D1 ){
      pinMode(espPins[i], INPUT);
    }
  }
}

/**
 *  Read all defined Pins and return result as String
 * Every 10 Lines Add Headers
 */
String readAllPins() {
  String result = "";
  char data[100];

  // insert Header about Pin Numbers
  if ( !(loopCount++ % 10) ) {
    for (int i = 0; i < numOfPins; i++ ) {
      result += espPinNames[i] + " ";
    }
    result += "     Named Pin\n";
    for (int i = 0; i < numOfPins; i++ ) {
      sprintf(data,"%02i",espPins[i]);
      result += data;
      result += " ";
    }
    result += "     Pin Number GPIOx\n";
  
  }

  // Add values of each Pin
  for (int i = 0; i < numOfPins; i++ ) {
    result += readPin( espPins[i]);
  }
  return result;
}

/**
 *  Read a single Pin and return result as String
 */
String readPin( int pin) {
  String result = "";
  result += digitalRead(pin);
  result += "  ";
  return result;
}


void setup() {
  Serial.begin(115200);
  Serial.println("Read All Digital Inputs");

  // If I do this on Wemos D1 Mini nothing can be seen on serial console
  setupAsInput();
}

void loop() {
  Serial.println(readAllPins());
  delay(500);
}
