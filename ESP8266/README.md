ESP8266
=======


ESP8266
-------

Die Chipserie ESP8266 ist inzwischen sehr weit verbreitet und findet sich auch in sehr vielen fertig zu kaufenden embeded Geräten.
Die Vorteile des Chips sind:
 - Vergleichsweise günstig: Der reine Chips fängt mit €1,26 an.
 - Integrierte WLAN Unterstützung
 - Kann mit der Standard Arduino Entwicklungsumgebung programmiert werden
 - viele schon fertige Libraries auf ESP8266 portiert



Entwicklungs Umgebung
---------------------
Links to descriptions of how to install the Development Environment,

 - [Anleitung zur Installation der Entwicklungsumgebung](https://makesmart.net/esp8266-d1-mini-programmieren/) In der Kurzfassung:
   + Download der [Arduino Entwicklungsumgebung](https://www.arduino.cc/en/Main/Software)
   + Unter Voreinstellungen setzen der zusätzliche Boardverwalter URLs:
     https://arduino.esp8266.com/stable/package_esp8266com_index.json
   + In der Arduino-IDE: Werkzeuge - Board - Boardverwalter: Suche nach "Wemos" und installieren der "ESP8266"-Boards



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

   
Pinout:
 - [Suche nach Wemos D1 Pinout](https://duckduckgo.com/?q=wemos+d1+pinout&t=canonical&iar=images&iax=images&ia=images)
   Die Pinbelegungen zu den Wemos Chips sind durch eine einfache Suche zu finden:

{|
|+
! Pin
! Function
! ESP-8266 Pin
|-
| A0 	| Analog input, max 3.2V 	A0
D0 	IO 	GPIO16
D1 	IO, SCL 	GPIO5
D2 	IO, SDA 	GPIO4
D3 	IO, 10k Pull-up 	GPIO0
D4 	IO, 10k Pull-up, BUILTIN_LED 	GPIO2
D5 	IO, SCK 	GPIO14
D6 	IO, MISO 	GPIO12
D7 	IO, MOSI 	GPIO13
D8 	IO, 10k Pull-down, SS 	GPIO15
G 	Ground 	GND
5V 	5V 	-
3V3 	3.3V 	3.3V
}

Examples:
https://github.com/wemos/D1_mini_Examples/tree/master/examples


Sonoff Geräte
-------------
Für Fertige Geräte eignen sich recht gut die Geräte von [Sonoff](https://duckduckgo.com/?q=sonoff&t=canonical&iax=images&ia=images). DIe Bandbreite rangiert von Relays über Taster zu weiteren. DIe Sonoff Geräte können sehr leicht mit neuer Firmware geflasht werden.



Firmware Packages
-----------------
Bei der fertigen Firmware kann aber auch eines der bekannten fertigen binaries verwendet werden.
 - [Tasmota](https://github.com/arendst/Tasmota)
 - [ESP-Easy](https://www.letscontrolit.com/wiki/index.php/ESPEasy)

