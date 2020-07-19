Qualitätssicherung
==================

Im Laufe eine Projektes ist es natürlich immer wichtig, daß auch alles immer so funktioniert, wie 
es gedacht war. Hier kommt dann die Qualitätssicherung in's Spiel.

Pflichtenheft
-------------
Um Qualität zu beschreiben ist es zuerst mal wichtig zu wissen was das Ziel des Projektes ist. Dazu schreiben wir unser Pflichtenheft.
In unserem Beispiel des Hand-Wash-Timers könnte ein sehr vereinfachtes Pflichtenheft in etwa so aussehen

 - Ein Ablauftimer von 20Sekunden
 - Triggern durch unseren Distanzsensor
 - Im Ruhezustand wird mit den LEDs eine Uhr angezeigt
 - Initialer LED Test soll alle LEDs einmal im Kreis herum einschalten und dann wieder aus
  
Testen
------
Um sicher zu sein, daß die aktuelle Soft und Hardwarekombination auch die Anforderungen aus dem Pflichtenheft erfüllt muss man testen

Laufzeit des Timers
 - Stoppuhr nehmen und kontrollieren, ob der Timer genau 20 Sekunden braucht
 - Masstab nehmen und kontrollieren  
 - Ist am Ende des Timers das doppelte Blinken zu sehen
 - Geht nach dem Timer die Uhr-Anzeige wieder weiter
 - Bewegt sich die Sekunden-LED gleichmäßig oder Stockt sie hin und wieder
 
LEDs
 - Ist 0 oben bei den LEDs
 - Gehen im initialen Selbsttest alle LEDs an
  
 
Testen besonders der Randfälle
 - Zeigt die UIhr bei 0 Uhr auch das richtige an
 - zeigt die Uhr auch bei 24 Uhr das richtige an
 - Werden die Stunden richtig angezeigt
 - Hat der Minutenzeige über den Stundenzeiger vorrang in der Anzeige (Wenn beide dide gleiche LED zum leuchten bringen würden)
  - Stimmen die Farben der LEDs
   

  
  