ESP8266
=======


[ESP8266](https://en.wikipedia.org/wiki/ESP8266)
------------------------------------------------

Die Chipserie ESP8266 ist inzwischen sehr weit verbreitet und findet sich auch in sehr vielen fertig zu kaufenden embeded Geräten.
Die Vorteile des Chips sind:
 - Vergleichsweise günstig: Der reine Chips fängt mit €1,26 an.
 - Integrierte WLAN Unterstützung
 - Kann mit der Standard Arduino Entwicklungsumgebung programmiert werden
 - viele schon fertige Libraries auf ESP8266 portiert
 - In vielen Geräten verwendet. [Sonoff](https://sonoff.tech/), 



Entwicklungs Umgebung
---------------------
Da es schon einige gute Anleitungen gibt wie man für einen Wemos-D1-Mini die passende Entwicklungsumgebung installiert, verweise ich nur darauf.

 - [Anleitung zur Installation der Entwicklungsumgebung](https://makesmart.net/esp8266-d1-mini-programmieren/)
   Wenn man sowas noch nie gemacht hat, wird man vermutlich zum installieren der Arduino-IDE ca. 30 min und zum Einrichten ohne test ca 20 min brauchen.

In der Kurzfassung für diejenigen, die es schon mal gemacht haben und sich nur noch an die Schritte erinnern wollen:
   + Download der [Arduino Entwicklungsumgebung](https://www.arduino.cc/en/Main/Software).
   + Unter Voreinstellungen setzen der zusätzliche Boardverwalter URLs:</br>
     https://arduino.esp8266.com/stable/package_esp8266com_index.json
   + Den Compiler und die Tools für die Wemos Devices hinzufügen.</br>
     Menü: Werkzeuge - Board - Boardverwalter: Suche nach "Wemos" und installieren der "ESP8266"-Boards
   + Nachdem das Device angeschlossen ist muss der Port eingestellt werden.</br>
     Menü: Werkzeuge - Port</br>
     Sollte kein Port passend zu dem angeschlossenen Gerät auftauchen, so ist ein passender USB-Seriell Treiber zu installieren.
   + Für den Compiler muss das richtige Board ausgewählt werden.</br>
     Menü: Werkzeuge - Board: "Lolin(Wemos)D1 R1" oder entsprechend
   + Um Libraries zu verwenden müssen sie zuerst in der IDE eingebunden werden.</br>
     Menü: Sketch - Bibliothek einbinden


Wemos D1 Mini (Lolin D1 Mini)
-----------------------------

Eine Variante des ESP8266 ist die Wemos D1 Mini Serie. Inzwischen (Lolin D1 Mini)
Vorteil:
 - USB-Konverter(Seriell und Stromversorgung) ist schon integriert; damit auch leicht über ein standard USB-Netzteil mit Strom zu versorgen.
 - Mit fertigen Shields kann man schon recht viel machen:
    + [Shields bei Lolin](https://www.wemos.cc/en/latest/d1_mini_shiled/index.html)
    + [Shields in der Suchmaschine](https://duckduckgo.com/?q=wemos+d1+mini+shield&t=canonical&iax=images&ia=images) 
 - Stromversorgung über 3.3 oder 5V
 - Viele schon fertige Libraries auf ESP8266 portiert

[Programmierung](programmierung/README.md)
---------------------------------------

In der Sektion [Programmierung](programmierung/README.md) sind verschiedenste Beispiele referenziert.

   
Anschlüsse Wemos D1 Mini (Lolin D1 Mini)
----------------------------------------

 - [Suche nach Wemos D1 Pinout](https://duckduckgo.com/?q=wemos+d1+pinout&t=canonical&iar=images&iax=images&ia=images)
   Die Pinbelegungen zu den Wemos Chips sind durch eine einfache Suche zu finden:

 | Pin |ESP Pin | Additional Function    | Wemos Shields         |
 |:----|:-------|:-----------------------|:----------------------|
 | A0  | A0	| Analog input, max 3.2V |			
 | D0  | GPIO16	|		    	 | Wake 	        
 | D1  | GPIO5	| SCL(I²C) 		 | Wemos Relay Shield    
 | D2  | GPIO4	| SDA(I²C)		 | 
 | D3  | GPIO0	| 10k Pull-up 		 | Wemos Button Shield   
 | D4  | GPIO2	| 10k Pull-up, BUILTIN_LED  | 	       		
 | D5  | GPIO14	| SCK 	       		 | Default SCL of Wire.h; Default SCLK of SPI
 | D6  | GPIO12	| MISO(SPI) 		 | 
 | D7  | GPIO13	| MOSI(SPI) 		 | 
 | D8  | GPIO15	| 10k Pull-down, SS(SPI) |
 | G   | GND	| Masse 		 |
 | 5V  | 5V 	| 5V 			 |
 | 3V3 | 3.3V 	| 3.3V		 	 |

Die Pins D0-D8 können standard mäßig als Digital In/Digital Out pins verwendet werden.
Die Pins können jeweils als digital IO, interrupt, pwm, I2C oder one-wire verwendet werden.

Anschlussmöglichkeiten:
-----------------------

Es gibt verschiedene Möglichkeiten andere Devices an zu schliessen.

 - Digital IO:</br>
   Man kann die einzelnen Pins als digitalen Eingang oder Ausgang verwenden.
   Hierbei entspricht
    + 3.2V einem Wert von 1 (An)
    + 0V einem Wert von 0 (Aus)

 - PWM:</br>
   "Puls Weiten Modulation" wird z.B. verwendet um:
   	 + um verschiedenen Intensität von LEDs zu steuern.
	 + Modellbau-Servos an zu steuern.

 - [I²C Interface](https://de.wikipedia.org/wiki/I%C2%B2C)</br>
  uses 2 pins, data and clock.
  https://en.wikipedia.org/wiki/I²C

    + SDA: Serial Data Line (D2/GPIO4 on the Wemos D1 Mini)
    + SCL: Serial Clock Line (D1/GPIO5 on the Wemos D1 Mini)

 - SPI:</br>
  https://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus
  SPI uses 4 pins, MISO, MOSI, SCLK and SS.

    + SCLK: Serial Clock (D5/GPIO14 on the Wemos D1 Mini).
    + MOSI: Master Output Slave Input (D7/GPIO13 on the Wemos D1 Mini)
    + MISO: Master Input Slave Output (D6/GPIO12 on the Wemos D1 Mini)
    + SS: Slave Select (D8/GPIO15 on the Wemos D1 Mini)

 - Interrupt:</br>
   Die Pins können verwendet werden um bei einem 1=>0 oder 0=>1 Übergang eine Funktion zu triggern.

 - Soft Serial:</br>
   Man kann die Digitalpins so programmieren, daß sie als serielle Schnittstelle agieren.
   Ein Bsp ist das lesen des RFID Readers RDM6300.

Examples:
https://github.com/wemos/D1_mini_Examples/tree/master/examples

Hardware
--------
Verschiedenste Hardware für die Embedded Spielereien:
[Hardware](Hardware/README.md)



Sonoff Geräte
-------------
Für Fertige Geräte eignen sich recht gut die Geräte von [Sonoff](https://duckduckgo.com/?q=sonoff&t=canonical&iax=images&ia=images).
Die Bandbreite rangiert von Relays über Taster zu weiteren.
Die Sonoff Geräte können sehr leicht mit neuer Firmware geflasht werden, deswegen sind sie im DIY-Home-Automation Bereich recht beliebt.




Home-Automation
---------------

Für die eine oder andere Aufgabe gibt es schon fertige Packages.
Diese kann man als binary runter laden und direkt flashen.
Vorteil ist, daß hier auch schon die WLAN Anbindung, eine MQTT Anbindung fertig integriert ist und man sich über das Handling keine Gedanken machen muss.
Bei der fertigen Firmware kann aber auch eines der bekannten fertigen binaries verwendet werden.
 - [Tasmota](https://github.com/arendst/Tasmota)
 - [ESP-Easy](https://www.letscontrolit.com/wiki/index.php/ESPEasy)

Diese fertigen Binaries arbeiten üblicherweise mit einem Home-Automation System zusammen.

Hier wird zur Kommunikation MQTT verwendet. Als MQTT Server kann z.B. [mosquito](https://mosquitto.org/) verwendet werden.

Als Home-Automation System wird unter anderem gerne [OpenHab](https://www.openhab.org/) verwendet.
