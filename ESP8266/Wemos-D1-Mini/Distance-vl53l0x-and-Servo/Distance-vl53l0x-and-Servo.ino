/**
  Example taken from
    http://www.esp8266learning.com/vl53l0x-time-of-flight-sensor-and-esp8266.php

  Datasheet:
    https://www.st.com/resource/en/datasheet/vl53l0x.pdf

  Features of sensor:
    Measuring Field of view covered (FOV = 25 degrees)
    Measuring Range: (normal 1.2m) (long distance 2m)
    Measuring Time:
      Total time including processing: 33ms(typical)
      Measuring only: 20ms(default Accurycy +/-5%) 300ms(High Accuracy +/-3%)
    Operating voltage 2.6 to 3.5 V
    940 nm laser
    I2C Up to 400 kHz (FAST mode) serial bus
    I2C Address: 0x52

  Buy:
    https://www.aliexpress.com/item/32842745623.html
    Price: 3.15€

**/

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include "Adafruit_VL53L0X.h"
#include <Servo.h>
#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

ESP_WiFiManager ESP_wifiManager("ESP_Configuration");


#define PIN_SERVO D8
#define SERVO_POS_MIN 30
#define SERVO_POS_MAX 150
#define SERVO_INCREMENT 2

Adafruit_VL53L0X lox = Adafruit_VL53L0X();

Servo myservo;  // create servo object to control a servo


ESP8266WebServer server(80);

float result[SERVO_POS_MAX + 2];

int servoPos = SERVO_POS_MIN;
int servoIncrement = 5;


void printStatus(int i , float dist_cm) {
  Serial.print("# i=");
  Serial.print(servoPos );
  // Serial.print("Distance (cm): ");
  Serial.print("\t");
  Serial.print(" d=");

  Serial.print(dist_cm );
  Serial.print("\r");
}

void printResult(int i , float dist_cm) {
  Serial.print("segment(i=");
  Serial.print(servoPos );
  // Serial.print("Distance (cm): ");
  Serial.print("\t");
  Serial.print(",d=");

  Serial.print(dist_cm );
  Serial.println(");");
}

void printResults() {

  Serial.println();
  Serial.println();
  Serial.println("# ===========================================================");

  for ( int i = SERVO_POS_MIN ; i <= SERVO_POS_MAX; i++) {
    printResult(i, result[i]);
  }

  Serial.println();
  Serial.println();
  Serial.println();
  Serial.println("module segment(i=0,d=20){");
  Serial.println("  if ( d < 0) {");
  Serial.println("    outOfRange(i=i);");
  Serial.println("  } else {");
  Serial.println("    rotate([0,90,i]) cylinder(d1=1,d2=0.4226*d,h=d);");
  Serial.println("  }");
  Serial.println("}");
  Serial.println("");
  Serial.println("module outOfRange(i=0){");
  Serial.println("      color(\"red\")");
  Serial.println("        rotate([0,90,i]) cylinder(d1=1,d2=1,h=1200);");
  Serial.println("    }");
  Serial.println("}");
  Serial.println("");
}




void handleRoot() {
  char temp[400];
  int sec = millis() / 1000;
  int min = sec / 60;
  int hr = min / 60;

  snprintf(temp, 400,

           "<html>\
  <head>\
    <meta http-equiv='refresh' content='5'/>\
    <title>ESP8266 Distance</title>\
    <style>\
      body { background-color: #cccccc; font-family: Arial, Helvetica, Sans-Serif; Color: #000088; }\
    </style>\
  </head>\
  <body>\
    <h1>Hello from ESP8266 Distance Sensor</h1>\
    <p>Uptime: %02d:%02d:%02d</p>\
   <img src=\"/test.svg\" />\
   </body>\
</html>",

           hr, min % 60, sec % 60
          );
  server.send(200, "text/html", temp);
  
}


void handleNotFound() {
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";

  for (uint8_t i = 0; i < server.args(); i++) {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }

  server.send(404, "text/plain", message);
}


void drawGraph() {
  String out;
  out.reserve(2600);
  char temp[70];
  out += "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"400\" height=\"150\">\n";
  out += "<rect width=\"400\" height=\"150\" fill=\"rgb(250, 230, 210)\" stroke-width=\"1\" stroke=\"rgb(0, 0, 0)\" />\n";
  out += "<g stroke=\"black\">\n";
  int y = rand() % 130;
  for (int x = 10; x < 390; x += 10) {
    int y2 = rand() % 130;
    sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, 140 - y, x + 10, 140 - y2);
    out += temp;
    y = y2;
  }
  out += "</g>\n</svg>\n";

  server.send(200, "image/svg+xml", out);
}

void setup() {
  Serial.begin(115200);

  ESP_wifiManager.setDebugOutput(true);

  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  ESP_wifiManager.autoConnect();

  Serial.println("Ataching Servo ...");
  myservo.attach(PIN_SERVO);  // attaches the servo
  myservo.write(servoPos );

  // VL53L0X
  Serial.println("Conneting Adafruit VL53L0X ...");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    while (1);
  }
  // power
  Serial.println(F("VL53L0X API Simple Ranging example\n\n"));



  Serial.println("");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (MDNS.begin("esp8266")) {
    Serial.println("MDNS responder started");
  }

  // Register URLs to answer
  server.on("/", handleRoot);
  server.on("/test.svg", drawGraph);
  server.onNotFound(handleNotFound);
  server.begin();
  Serial.println("HTTP server started");
}


void loop() {
  VL53L0X_RangingMeasurementData_t measure;

  // Serial.print("Reading a measurement... ");
  lox.rangingTest(&measure, false); // pass in 'true' to get debug data printout!

  if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    float dist_cm = measure.RangeMilliMeter / 10.0;
    printStatus(servoPos, dist_cm);
    result[servoPos] = dist_cm;
  } else {
    result[servoPos] = -1;
    printStatus(servoPos, -1);
  }

  // Move Servo
  servoPos += servoIncrement;
  if ( servoPos > SERVO_POS_MAX ) {
    servoPos = SERVO_POS_MAX;
    // servoPos = SERVO_POS_MIN ;
    servoIncrement = -SERVO_INCREMENT;
    printResults();
  }
  if ( servoPos < SERVO_POS_MIN ) {
    servoPos = SERVO_POS_MIN;
    servoIncrement = SERVO_INCREMENT;
    printResults();
  }
  myservo.write(servoPos );
  delay(200);

  server.handleClient();
  MDNS.update();
}
