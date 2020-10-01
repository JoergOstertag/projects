3D-Scanner
----------

Ziel dieses Projektes war es, einen 3D scanner zu bauen der Innenräume scannen kann.

Angefangen habe ich mit dem Versuch einen Ultraschallsensor auf zwei Servos zu montieren und diesen jeweils die Distanz messen zu lassen. Der Erfolg war rechtmäßig wie sich später herausstellte war das Problem, dass der Öffnungswinkel des Ultraschallsensors 45° beträgt.

Der zweite Versuch war mit einem relativ günstigen LIDAR Sensor, aber dieser hatte dann ebenfalls einen Öffnungswinkel von insgesamt 20 Grad. Dies ist immer noch zu viel um ein vernünftiges Bild zu bekommen.
Jedoch zeigte sich schon an der Software, dass das Problem prinzipiell damit zu lösen sein könnte, wenn man das Problem mit dem Öffnungswinkel löst.
Die nächste Version war dann den Garmin LIDAR Sensor mit nur noch 1 bis 2 Grad Öffnungswinkel zu nehmen und diesen über zwei kräftige Servos zu bedienen.


3D-Printable Parts are taken from https://github.com/bitluni/3DScannerESP8266

