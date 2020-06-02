Hand Wash Timer Build with a Servo
==================================

Inspiriert durch [das Video auf youtube](https://www.youtube.com/watch?v=CEpfipV1_3w) habe ich mir überlegt dass es recht
einfach ist auch Anfängern mit so einem Beispiel das Programmieren von embedded Geräten näher zu bringen.
Daher habe ich mich hingesetzt und mir angeschaut wie man diese Beispiele sehr einfach implementieren kann.

Wir fangen mit der [installation der Entwicklungsumgebung](../ESP8266/README.md) an.
Danach machen wir mit einfachen Programmierbeispiele weiter. Das zeigt uns auch gleich ob die Entwicklungsumgebung richtig installiert ist.
Hierzu verwenden wir das einfache Blink Bspiel, das zu dem COmpiler des ESP8266 gehört.

Am Anfang eines Projektes liegt üblicherweise die Brainstorming Phase.
Dieser Phase überlegen wir uns was ist das Ziel?
Welche Funktionen soll das Gerät am Ende haben?
Im nächsten Schritt ermitteln wir welche Bauteile wir brauchen um dieses Ziel zu erreichen.
Wir schreiben uns dann diese Informationen in einem Anforderungsblatt nieder.
Dadurch ergeben sich dann auch die Komponenten die für das Projekt gebraucht werden.
Wenn einmal die Anfordeungen klar sind, kann man sich daran machen die Komponenten einzeln ans laufen zu bekommen.
In unserem Fall sind es das Grundsystem (Die embedded CPU mit der Platine), danach der Modellbauservo und zuletzt der Distanzsensor.
Jede diese Komponenten kann man einzeln testen und sich mit der Bedienung und Verwendung vertraut machen.
Fangen wir mit der CPU Platine an. In unserem Fall verwenden wir einen wemos D1 Mini.
Der Vorteil dieser Platine ist dass man sehr wenig Löten muss um sie ans laufen zu bekommen.
Als Beispiel verwenden wir das Standard Blink example das in der Entwicklungsumgebung schon mitgeliefert wird.

Danach verwenden wir einfache Bibliotheken um die Geräte die wir später verwenden wollen anzusteuern.
Hierbei gehen wir so vor, daß wir zuerst die benötigte Bibliothek anhand des Sensors oder Gerätes identifizieren.
Diese Bibliothek wird dann auf dem Entwicklungssystem installiert. Üblicherweise bringen die Bibliotheken dann
auch schon Beispiele mit, die die verwendung der Bibliothek und die Ansteuerung des Sensors zeigen.

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

