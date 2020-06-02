Allgemeiner EInstieg in die Embedded Programmierung
===================================================


[Installation der Entwicklungsumgebung](ESP8266/README.md)
---------------------------------------------------------
Wir fangen mit der [installation der Entwicklungsumgebung](ESP8266/README.md) an.
Danach machen wir mit einfachen Programmierbeispiele weiter. Das zeigt uns auch gleich ob die Entwicklungsumgebung richtig installiert ist.
Hierzu verwenden wir das einfache Blink Baispil, das beim Compiler für den ESP8266 dankenswerterweise gleich als Beispiel mit kommt.



Planung und Strukturierung eines Projektes
------------------------------------------

 - *Ermitteln der Zeilstellung:*

   In unserem Fall gilt es eine kleines Embedded Gerät zu designen, zu bauen und zu programmieren.
   Da unser aller Leben gerade durch Covid sehr geprägt ist wollen wir einen Bezug dazu herstellen.
   Inspiriert durch andere Programmiereer und deren Projekte wollen wir daher einen "Hand Wasch Timer" bauen.

 - *Brainstorming:*

   Am Anfang eines Projektes liegt üblicherweise die Brainstorming Phase.
   Dieser Phase überlegen wir uns wie wir unser Ziel erreichen können.
   Welche Funktionen soll das Gerät am Ende haben?
   Unser Ziel ist es ja, daß wir dabei unterstützt werden unsere Hände lange genug mit Seife zu waschen.
   Daher brauchen wir irgend etwas, daß uns signalisiert wenn wir unsere Hände lange genug gewaschen haben.
   Da wir auch wissen, daß die minimale Zeit zum Händewaschen 20 Sekunden sein sollte ist eine weitere Vorraussetzung diese 20Sekunden zu timern.
   Jetzt fehlt uns noch irgendwas das den ganzen Vorgang einleitet; sozusagen ein Start Trigger.
   Da wir als Menschen gerne ungeduldig sind wollen wir auch gerne wissen, wie lange es noch dauert. Also wäre ein nettes plus für uns während des Timers zu sehen wie lange wir noch waschen müssen.


 - *Welche Komponenten werden benötigt*:

   Im nächsten Schritt ermitteln wir welche Komponenten wir brauchen um dieses Ziel zu erreichen. In unserem Fall brauchen wir also
    - Etwas zu triggern des Anfangs (Wir haben hier einen Distanzsensor gewählt)
    - Eine komponente, die uns die 20 Sekunden ermittelt (als Timer wählen wir entweder die Funktion sleep() oder miliseconds() )
    - Eine komponente, die uns sagt wie weit wir sind und diese als Fortschrittsanzeige visualisiert (Als Fortschrittsanzeige wählen wir entweder einen Modelbau Servo mit Zeiger oder einen Neopixel Ring) 
    - Eine Komponente die uns das Ende signalisiert (Hier kann die Fortschrittsanzeige verwendet werden)

Dadurch ergeben sich dann auch die Komponenten die für das Projekt gebraucht werden.

Ein nächster Schritt ist es die einzelnen Komponenten Komponenten separiert voneinander ans laufen zu bekommen.
Für den ersten Versuch verwenden wir die Variante mit einem Modellbauservo als Fortschrittsanzeige.
In unserem Fall sind es also
 - Das Grundsystem (Die embedded CPU mit der Platine)
 - Der Modellbauservo
 - Der Distanzsensor.
Jede diese Komponenten kann man einzeln testen und sich mit der Bedienung und Verwendung vertraut machen.

Das Grundsystem (Die embedded CPU mit der Platine)
--------------------------------------------------
Fangen wir mit der CPU Platine an. In unserem Fall verwenden wir einen wemos D1 Mini.
Der Vorteil dieser Platine ist dass man sehr wenig Löten muss um sie ans laufen zu bekommen.
Als Beispiel verwenden wir das Standard Blink example das in der Entwicklungsumgebung schon mitgeliefert wird.

Bibliotheken für weitere Komponenten
------------------------------------
Viele verschiedene Geräte (Sensoren und Aktoren) können von so einem Embeded System angesteuert/abgefragt werden.
Damit sich nicht jeder Entwickler wieder von neuem mit der Programmierung der LowLevel Funktionen dieser Geräte kümmern muss
haben eineige Programmierer sich die Mühe gemacht und die grundsätzliche Ansteuerung solcher Geräte in eine Bibliothek zu verpacken.
Dieser Umstand macht uns das Leben sehr viel leichter.
Daher schauen wir als allererste nach, ob es denn schon eine Bibliothek zur Verwendung des von uns gewünschten Gerätes gibt.

Hierbei gehen wir so vor, daß wir zuerst die benötigte Bibliothek anhand der Typenbezeichnung des Sensors oder Gerätes identifizieren.
Viele der Bibliotheken sind schon direkt in der "Bibliotheksverwaltung" innerhalb der IDE direkt herunterladbar.
Unser nächster Schritt ist dann das installieren der Bibliothe auf diesem Wege.
Wenn die Bibliothek in der IDE istalliert ist schauen wir uns die zur Bibliothek mit gelieferten Beispiele an.
Denn üblicherweise bringen die Bibliotheken auch schon Beispiele mit, die die Verwendung der Bibliothek und die Ansteuerung des Sensors zeigen.

