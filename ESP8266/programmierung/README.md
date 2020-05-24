Programmierung
==============

Bevor ihr weiter in die Programmierung einsteigt, kann ich noch empfehlen, sich mit einem Versionsverwaltungssystem zu beschäftigen. Es macht Sinn, nach jedem Schritt, den man ans laufen bekommen hat diesen im Versionsverwaltungssystem zu sichern.

Zur eigentlichen Programmierung mit der Arduino IDE und über die Sprache finden sich viele Links. Die Original Referenz bei arduino.cc ist für das meisste ein guter Einstieg. 
 - [Sprachreferenz](https://www.arduino.cc/reference/en/)


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
  

Wemos DOT Matrix Display
------------------------

Library [WEMOS_Matrix_LED](https://github.com/wemos/WEMOS_Matrix_LED_Shield_Arduino_Library)
../libraries/WEMOS_Matrix_LED_Shield_Arduino_Library-master/examples/draw_dot/draw_dot.ino

