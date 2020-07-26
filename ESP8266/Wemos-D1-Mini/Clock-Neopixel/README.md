Uhr mit einem Neopixel Ring
===========================

Mittels eines Neopixel Rings wird die aktuelle Uhrzeit angezeigt.

 - Im setup wird mit dem Wifimanager eine Verbindung zum lokalen WiFi hergestellt.
 - der Wemos synchronisiert dann die Uhrzeit mittels NTP (Network Time Protokoll)
 - Es wird dann die Uhrzeit in Hour,Minute,Second zerlegt. Diese werden dann auf die 24 LEDs im Neopixel Ring umgerechnet.
 - Zuerst werden alle Pixel auf die Hintergrundfarbe gesetzt.
  - Danach wird je ein Pixel in den passenden Farben für die Stunde,Minute und sekunde gesetzt.
  
![Clock Demo with wired Neopixel](img/Clock-Neopixel-x8-1.mp4]

![Clock](img/clock-neopixel.gif)
