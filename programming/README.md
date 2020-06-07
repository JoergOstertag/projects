Allgemeiner Einstieg in die Embedded Programmierung
===================================================


[Installation der Entwicklungsumgebung](ESP8266/README.md)
---------------------------------------------------------
Wir fangen mit der [installation der Entwicklungsumgebung](ESP8266/README.md) an.
Danach machen wir mit einfachen Programmierbeispiele weiter. Das zeigt uns auch gleich ob die Entwicklungsumgebung richtig installiert ist.
Hierzu verwenden wir das einfache Blink Beispiel, das beim Compiler fÃ¼r den ESP8266 dankenswerterweise gleich als Beispiel mit kommt.



Planung und Strukturierung eines Projektes
------------------------------------------

 - *Ermitteln der Zeilstellung:*

   In unserem Fall gilt es eine kleines Embedded GerÃ¤t zu designen, zu bauen und zu programmieren.
   Da unser aller Leben gerade durch Covid sehr geprÃ¤gt ist wollen wir einen Bezug dazu herstellen.
   Inspiriert durch andere Programmiereer und deren Projekte wollen wir daher einen "Hand Wasch Timer" bauen.

 - *Brainstorming:*

   Am Anfang eines Projektes liegt Ã¼blicherweise die Brainstorming Phase.
   Dieser Phase Ã¼berlegen wir uns wie wir unser Ziel erreichen kÃ¶nnen.
   Welche Funktionen soll das GerÃ¤t am Ende haben?
   Unser Ziel ist es ja, daÃŸ wir dabei unterstÃ¼tzt werden unsere HÃ¤nde lange genug mit Seife zu waschen.
   Daher brauchen wir irgend etwas, daÃŸ uns signalisiert wenn wir unsere HÃ¤nde lange genug gewaschen haben.
   Da wir auch wissen, daÃŸ die minimale Zeit zum HÃ¤ndewaschen 20 Sekunden sein sollte ist eine weitere Vorraussetzung diese 20Sekunden zu timern.
   Jetzt fehlt uns noch irgendwas das den ganzen Vorgang einleitet; sozusagen ein Start Trigger.
   Da wir als Menschen gerne ungeduldig sind wollen wir auch gerne wissen, wie lange es noch dauert. Also wÃ¤re ein nettes plus fÃ¼r uns wÃ¤hrend des Timers zu sehen wie lange wir noch waschen mÃ¼ssen.


 - *Welche Komponenten werden benÃ¶tigt*:

   Im nÃ¤chsten Schritt ermitteln wir welche Komponenten wir brauchen um dieses Ziel zu erreichen. In unserem Fall brauchen wir also
    - Etwas zu triggern des Anfangs (Wir haben hier einen Distanzsensor gewÃ¤hlt)
    - Eine komponente, die uns die 20 Sekunden ermittelt (als Timer wÃ¤hlen wir entweder die Funktion sleep() oder miliseconds() )
    - Eine komponente, die uns sagt wie weit wir sind und diese als Fortschrittsanzeige visualisiert (Als Fortschrittsanzeige wÃ¤hlen wir entweder einen Modelbau Servo mit Zeiger oder einen Neopixel Ring) 
    - Eine Komponente die uns das Ende signalisiert (Hier kann die Fortschrittsanzeige verwendet werden)

Dadurch ergeben sich dann auch die Komponenten die fÃ¼r das Projekt gebraucht werden.

Ein nÃ¤chster Schritt ist es die einzelnen Komponenten Komponenten separiert voneinander ans laufen zu bekommen.
FÃ¼r den ersten Versuch verwenden wir die Variante mit einem Modellbauservo als Fortschrittsanzeige.
In unserem Fall sind es also
 - Das Grundsystem (Die embedded CPU mit der Platine)
 - Der Modellbauservo
 - Der Distanzsensor.
Jede diese Komponenten kann man einzeln testen und sich mit der Bedienung und Verwendung vertraut machen.

Das Grundsystem (Die embedded CPU mit der Platine)
--------------------------------------------------
Fangen wir mit der CPU Platine an. In unserem Fall verwenden wir einen wemos D1 Mini.
Der Vorteil dieser Platine ist dass man sehr wenig LÃ¶ten muss um sie ans laufen zu bekommen.
Als Beispiel verwenden wir das Standard Blink example das in der Entwicklungsumgebung schon mitgeliefert wird.

Grundaufbau von Arduino Sketches
--------------------------------
# setup()

## loop()


Bibliotheken fÃ¼r weitere Komponenten
------------------------------------
Viele verschiedene GerÃ¤te (Sensoren und Aktoren) kÃ¶nnen von so einem Embeded System angesteuert/abgefragt werden.
Damit sich nicht jeder Entwickler wieder von neuem mit der Programmierung der Low-Level Funktionen dieser GerÃ¤te kÃ¼mmern muss
haben einige Programmierer sich die MÃ¼he gemacht und die grundsÃ¤tzliche Ansteuerung solcher GerÃ¤te in eine Bibliothek zu verpacken.
Dieser Umstand macht uns das Leben sehr viel leichter.
Daher schauen wir als aller erste nach, ob es denn schon eine Bibliothek zur Verwendung des von uns gewÃ¼nschten GerÃ¤tes gibt.

Hierbei gehen wir so vor, daÃŸ wir zuerst die benÃ¶tigte Bibliothek anhand der Typenbezeichnung des Sensors oder GerÃ¤tes identifizieren.
Viele der Bibliotheken sind schon direkt in der ["Bibliotheksverwaltung"](img/Libs-search-Wemos-Matrix.png) innerhalb der IDE direkt herunterladbar.
Wenn man hier die entsprechende Bibliothek gefunden hat einfach auswählen und installieren.

Vertraut machen durch Beispiele
-------------------------------

Um sich mit einer Bibliothek und einem neuen Gerät vertraut zu machen, ist ein schöner Einstieg die Beispiele zu dieser Bibliothek.
Die Beispiele findet man unter ![Datei Beispiele](img/Open-Example-for-Lib.png)
Das klappt natürlich nur, nachdem die Bibliothek in der Arduino-IDE installiert wurde.
Üblicherweise bringen die Bibliotheken schon Beispiele mit, die die Verwendung der Bibliothek und die Ansteuerung des Sensors zeigen.

Viele Bibliotheken haben einen sehr ähnlichen Aufbau und sind zur Verwending in ihrem Interface (Das was ein anderer Programmierer wissen muss) recht ähnlich aufgebaut.

EInbinden der Bibliothek:
 - #include<BbibliotheksName.h>
 	Es wird die Header Datei der Bibliothek mit einem #include<> Statement eingebunden.
 	Bsp.: #include <Servo.h>
 		
 - Objekt definition in den Bibliotheken:
 	Als nächstes wird ein Objekt definiert mittels dessen später auf die Resoutrce (Sensor/Aktor) zugegriffen werden kann.
 	
	Example:
		Servo myservo;  // create servo object to control a servo
		// twelve servo objects can be created on most boards
 	Dieses generierte Objekt könnte auch optionale Parameter beinhalten. 
 	
 	Example:
 		MLED mled(4); // Hier wird die Helligkeit der LEDs in der LED-Matrix mit angegeben.
 		
 

Projektstruktur mit Dateien





Debugging
---------

Für das Debugging eines Arduino scetches wird gerne die serielle Verbindung verwendet.  
 - Serieller Monitor
 []()
 - Tip: Änderung erzwingen, die eine Auswirkung haben muss

