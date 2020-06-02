Hand Wash Timer Build with a Servo
==================================

Inspiriert durch [das Video auf youtube](https://www.youtube.com/watch?v=CEpfipV1_3w) habe ich mir überlegt dass es recht
einfach ist auch Anfängern mit so einem Beispiel das Programmieren von embedded Geräten näher zu bringen.
Daher habe ich mich hingesetzt und mir angeschaut wie man diese Beispiele sehr einfach implementieren kann.

Modellbau Servo
---------------
Ein Beispiel ist die Ansteuerung eines [Modellbau Servos]().
Hierzu wird die entsprechende Bibliothek aus der Bibliotheksverwaltung für den Servo gewählt.
Anhand der schon in der Arduino IDE mitgelieferten Beispielen kann man sich auch schon ein gutes Bild machen wie so eine Bibliothek üblicherweise verwendet wird.
Am Beispiel des Servos ist es das Swipe Beispiel, das den Servo regelmäßig links rechts bewegen lässt.

Distanzsensor HC-SR04
---------------------
Das nächste Beispiel wird der Distanzsensor sein. Es ist ein [Ultraschall Distanzsensor HC-SR04]().
Auch für diesen gibt es verschiedene Bibliotheken. Hier wird es schon ein wenig schwieriger, denn man muss sich für eine der Bibliotheken entscheiden.
Nach ein wenig Recherche habe ich zwei Bibliotheken ausgemacht die recht vernünftig klingen.
Die Bibliothek [xxx]() kann einen Distanzsensor bedienen inklusive Temperaturkompensation.
Die Bibliothek [xxx]() könnte mehrere Distanzsensoren gleichzeitig bedienen allerdings ohne Temperaturkompensation.


This is an example Project with the intention to inspire beginners to start playing arround with embedded devices.

In times of Covid-19 this device will give you a hint how long you should wash your hands.


This is a Demo Code for a 20-seconds Hand Wash Timer.
If you get closer to the sonar distance sensor a timer starts 
and counts down from 20seconds to zero.

Displaing the timer is done with a standard Servo



Used Hardware:
   the cost for the electronic parts is about 7€ 
   based on bying 10 sets


D1 mini - Mini NodeMcu 4M bytes Lua WIFI Internet of Things development board based ESP8266 WeMos
   https://www.aliexpress.com/item/32651256441.html
   price: 2.216€

HC-SR04 to world Ultrasonic Wave Detector Ranging Module for arduino Distance Sensor
   https://www.aliexpress.com/item/32786749709.html
   price: 0.782€ 
   
Micro Servo Motor For Robot or RC Airplane SG90 9G
   https://www.aliexpress.com/item/4000093416296.html   
   price: 1.090€
   
Mini Breadboard kit for Arduino
   https://www.aliexpress.com/item/32564367417.htm
   price: 0.270€
 *
Dupont Line (small connection Wired)
   https://www.aliexpress.com/item/32956301840.html
   price for 40pins: 1.52€
   Need 
     - one set Male - Male
     - one set Male - Female
     
First Try for a housing (Simple copy paste from others)
   https://github.com/JoergOstertag/openScad/tree/master/HandwashTimer
   printing takes about 3h
   Material Cost about 1.46€

