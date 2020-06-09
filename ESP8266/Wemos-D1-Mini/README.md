Programmierung
==============


Als Anfang schauen wir ob alles funtktioniert mit einem einfachen "Hello World" Programm.

1-HelloWorld
------------

Dieses Beispiel dient zum einen dazu zu kontrollieren, ob alles richtig konfiguriert ist.
Zum anderen sieht man hier, wie man debug output auf die Konsole ausgibt.



2-HelloWorld-withCounter
------------------------

Jetzt kommt noch ein Zähler dazu. Und ein paar kleine if Bedingungen.



Blink
-----

Dies ist ein sehr weit verbreitetes Bsp. in dem ohne weitere externe Bauteile was zu sehen ist.<br/>
[01.Basics/Blink](https://github.com/wemos/D1_mini_Examples/tree/master/examples/01.Basics/Blink)


Modellbau Servo ansteuern
-------------------------

Um einen Modellbau Servo an zu steuern hilft die Bibliothek Servo.h. Das passende 
[Servo Beispiel](https://github.com/wemos/D1_mini_Examples/tree/master/examples/02.Special/Servo/Sweep)
gibt dazu einen guten Eindruck.



Zeit messen mit millis()
------------------------

Die [Verwendun von milis()](https://github.com/wemos/D1_mini_Examples/blob/master/examples/01.Basics/BlinkWithoutDelay/BlinkWithoutDelay.ino)
zeigt, wie man die real vergangene Zeit bestimmen kann und damit DInge auslösen kann.
Im ersten Moment denkt man, daß die Verwendung von deley() einem die Möglichkeit bietet in regelmäßigen Abständen DInge zu tun. Was aber hier nicht Beachtet ist, daß ja auch das ausführen des Codes dazwischen Zeit dauert. Dadurch würde das timing verfälscht werden.
Wenn man sich die reale Zeit in milisekunden anschaut kann man dan genau getimt operationen auslösen.


Helligkeit steuern mittels PWM
------------------------------

[Beispiel Fade](https://github.com/wemos/D1_mini_Examples/blob/master/examples/01.Basics/Fade/Fade.ino)
In dem Bsp wird mittels PWM(Pulse weiten Modulation) die Helligkeit der LED gesteuert. DIe zwei wesentlichen Teile sind:

 - pinMode(ledPin, OUTPUT);<br/>
   Hier wird der PIN auf Ausgabe gestellt

 - analogWrite(ledPin, brightness);<br/>
   hier wird durch unterschiedliche Pulsweite die Zeit in der die LED mit Strom versorgt wird gesteuert.
   Dadurch entsteht der eindruck, daß die LED heller oder dukler leuchtet. 
  

Wifi Verbindung und Zeit aus dem Internet(NTP)
----------------------------------------------

Im Beispiel [ESP_WiFiManager show Time](ESP_WifiManager-show-NTP-time) wird eine Wifi Verbindung aufgebaut. Über diese Verbindung wird dann die Zeit mittel dem NTP Protokoll aktualisiert. Danach wird dann die Zeit alle Sekunde auf der Konsole angezeigt.


Wemos DOT Matrix Display
------------------------

Library [WEMOS_Matrix_LED](https://github.com/wemos/WEMOS_Matrix_LED_Shield_Arduino_Library)
../libraries/WEMOS_Matrix_LED_Shield_Arduino_Library-master/examples/draw_dot/draw_dot.ino

