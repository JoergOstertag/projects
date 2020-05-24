#include <Arduino.h>

/*
 * Dieses Beispiel dient zum einen dazu zu kontrollieren, ob alles richtig konfiguriert ist.
 * Zum anderen sieht man hier, wie man debug output auf die Konsole ausgibt.
 */


// Dieser Teil wird beim booten einmalig ausgeführt
void setup() {

  // Initialisierung der Seriellen Schnittstelle.
  // Diese ist bei den Wemos-D1-Mini an den USB-Seriell-Konverter verbunden und kann durch den
  // Seriell Monitor in der IDE (Symbol rechts oben) zur Anzeige gebracht werden.

  // Der default für die serialle Schnittstelle ist in der IDE auf 9600 eingestellt. 
  // Da viele Beispiele aber 115200 als Baurate verwenden starten wir hier auch mit 
  // 115200 Baud. Dazu in der IDE bei geöffnetem Seriell Monitor rechts unten die 
  // Baudrate umstellen.
  Serial.begin(115200);

  // Wir fangen eine neue Zeile an, da vorher oft wirre Zeichen in der Konsole zu sehen sind
  Serial.println("");
  
  Serial.println("Initialisierung erfolgt.");

  Serial.println("Hello World :-)");
}



// die hier aufgeführten Dinge werden immer wieder ausgeführt
void loop() {

     // Gebe auf der Seriellen Schnittstelle etwas zum Debuggen aus
     Serial.println("Ein weiterer Loop");


    // Warte ein wenig. In diesem Falle 1000ms. was einer Sekunde entspricht.
    delay(1*1000); }
