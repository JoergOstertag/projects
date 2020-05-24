#include <Arduino.h>

/*
 * In diesem Bsp verwenden wir eine zählvariable und geben diese auf der seriellen Schnittstelle ausausgibt.
 */

void setup() {
    // Initialisierung der Seriellen Schnittstelle mit 115200 Baud
    Serial.begin(115200);
}

// Eine Variable zum zählen
int i = 0;

// die hier aufgeführten Dinge werden immer wieder ausgeführt
void loop() {

  // zähle die Variable i immer eins hoch
  i = i + 1;

  
  // Gebe auf der Seriellen Schnittstelle etwas zum Debuggen aus
  Serial.print("Loop Nummer ");
  Serial.print(i);
  Serial.println(".");


  // Ausgabe bei genau dem 10. Loop
  if ( i == 10 ) {
    Serial.println("Das war der 10. Loop");
  }


  // Immer wenn i durch 10 teilbar ist
  if ( 0 == (i % 10) ) {
    Serial.println("Es sind weitere 10 Loops vergangen");
  }
  

  // Warte 1 sekunde
  delay(1*1000);

}
