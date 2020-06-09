
/**
   Naming of Pin D0 ==> 16 // Wake
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

  @gbales Both I2C and SPI have clock pins.

  Most of the ESP8266 pins are digital IO pins, meaning the output high or low, 
  or toggle high/low rapidly with PWM.
  
  There is a single pin A0 which can handle analog. There is an ADC built into the ESP chip, but it only has 1 pin, and its limited to 3v.

  If you need more analog inputs, there are expansion modules you can use, 
  which give you multiple analog inputs, on a chip that communicates with 
  the ESP8266 over I2C. eg. ADS1115.

  https://en.wikipedia.org/wiki/I²C
  I2C uses 2 pins, data and clock.

    SDA: Serial Data Line (D2/GPIO4 on the Wemos D1 Mini)
    SCL: Serial Clock Line (D1/GPIO5 on the Wemos D1 Mini)

  https://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus
  SPI uses 4 pins, MISO, MOSI, SCLK and SS.

    SCLK: Serial Clock (D5/GPIO14 on the Wemos D1 Mini).
    MOSI: Master Output Slave Input (D7/GPIO13 on the Wemos D1 Mini)
    MISO: Master Input Slave Output (D6/GPIO12 on the Wemos D1 Mini)
    SS: Slave Select (D8/GPIO15 on the Wemos D1 Mini)

  It is possible to use the Arducam with an ESP8266.
  http://www.arducam.com/tag/arducam-esp8266/
  Looks like the Arducam connects using SPI, not I2C.

*/


void example1Button() {
  
  int digitalPin = D6;
  
  pinMode(digitalPin, INPUT_PULLUP); // Set pin 12 as an input w/ pull-up
  
  while (digitalRead(digitalPin) == HIGH) // While pin 12 is HIGH (not activated)
    yield(); // Do (almost) nothing -- yield to allow ESP8266 background functions
  
  Serial.println("Button is pressed!"); // Print button pressed message.
  
  pinMode(12, INPUT_PULLUP);
}
