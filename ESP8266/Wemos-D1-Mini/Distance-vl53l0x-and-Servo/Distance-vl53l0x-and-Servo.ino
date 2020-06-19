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
#define SERVO_POS_MIN 10
#define SERVO_POS_MAX 175
#define SERVO_INCREMENT 1
#define SERVO_TO_DEGREE 1.0

Adafruit_VL53L0X lox = Adafruit_VL53L0X();

Servo myservo;  // create servo object to control a servo

#define ACTIVATE_WEBSERVER true

ESP8266WebServer server(80);

float result[SERVO_POS_MAX + 2];

int servoPos = SERVO_POS_MIN;
int servoIncrement = 5;

void handleGet(){
  
}

void drawRoomLayout() {
  String out;
  out.reserve(2600);
  char temp[70];
  out += "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"800\" height=\"800\">\n";
  out += "<rect width=\"800\" height=\"800\" fill=\"rgb(50, 230, 210)\" stroke-width=\"1\" stroke=\"rgb(0, 0, 0)\" />\n";
  out += "<g stroke=\"black\">\n";
  int y = -1;
  int x = -1;

  for ( int i = SERVO_POS_MIN ; i <= SERVO_POS_MAX; i += SERVO_INCREMENT) {
    float degree = 90 - (i * SERVO_TO_DEGREE);
    float rad = (degree * 71) / 4068;
    float dist = result[i];
    float distPixel = dist * 5;
    int y2 = 400.0 + cos(rad) * distPixel;
    int x2 = 400.0 + sin(rad) * distPixel;
    /*
        Serial.print("deg: ");
        Serial.println(degree);
        Serial.print("rad: ");
        Serial.print(rad);
        Serial.print("\tdist: ");
        Serial.print(dist);
        Serial.print("\tdistPixel: ");
        Serial.print(distPixel);
        Serial.print(x2);
        Serial.print("\t");
        Serial.print(y2);
        Serial.println();
    */
    if ( x >= 0 && y >= 0 && x2 >= 0 && y2 >= 0) {
      sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, y, x2, y2);
      out += temp;
    }
    y = y2;
    x = x2;
  }
  out += "<line x1=\"400\" y1=\"0\" x2=\"400\" y2=\"800\" stroke=\"white\" stroke-width=\"1\" />\n";
  out += "<line x1=\"0\" y1=\"400\" x2=\"800\" y2=\"400\" stroke=\"white\" stroke-width=\"1\" />\n";
  out += "</g>\n</svg>\n";

  server.send(200, "image/svg+xml", out);
}


void printStatus(int i , float dist_cm) {
  Serial.print("# i=");
  Serial.print(servoPos );
  // Serial.print("Distance (cm): ");
  Serial.print("\t");
  Serial.print(" d=");

  Serial.print(dist_cm );
  Serial.println();
}


String upTimeString() {
  char temp[100];
  int sec = millis() / 1000;
  int min = sec / 60;
  int hr = min / 60;

  snprintf(temp, 100, "Uptime: %02d:%02d:%02d ", hr, min % 60, sec % 60 );
  String result = String(temp);
  return result;
}

void handleRoot() {

  String output = "<html>\
  <head>\
    <meta http-equiv='refresh' content='5'/>\
    <title>ESP8266 Distance</title>\
    <style>\
      body { background-color: #cccccc; font-family: Arial, Helvetica, Sans-Serif; Color: #000088; }\
    </style>\
  </head>\
";

  output += "<body>\n";
  output += "<h1>ESP8266 Distance Sensor</h1>\n\n";


  // Uptime
  output += upTimeString();

  // Open Scad Reference
  output += " < a href=\"/result.scad\">result.scad</a>\n\n";


  // HTML FORM
  
    output += "\
    <div>\
     <form action=\"/get\">\
        input1: <input type=\"text\" name=\"input1\">\
       <input type=\"submit\" value=\"Submit\">\
     </form><br>\
     <div class=\"slidecontainer\"> \
       <input type=\"range\" min=\"1\" max=\"100\" value=\"50\" class=\"slider\" id=\"myRange\">\
      </div>\
    </div>\
    \
    ";
  
  // Room Layout img Reference
  output += "\
    <div>Room Layout:<p/>\
      <img src=\"/roomLayout.svg\" />\
    </div>\
    \
    ";

  // Distances Graf img reference
  output += "\
    <div>\
    Distances:<p/>\
    <img src=\"/distGraph.svg\" />\
    </div>\
    ";

  // html End
  output += "\
    \
</body>\
</html>";
  server.send(200, "text/html", output);

}

void handleScad() {
  String output;
  output.reserve(64);

  output = "\n";
  output += "\n";
  output += "\n";
  output += "// ===========================================================\n";
  output += "// Distance Sensor\n";
  output += "// ===========================================================\n";

  for ( int i = SERVO_POS_MIN ; i <= SERVO_POS_MAX; i++) {
    output += "segment(i=";
    output += i ;
    output += "\t";
    output += ",dist=";
    output += result[i];
    output += ");\n";
  }

  output += "\n";
  output += "\n";
  output += "\n";
  output += "module segment(i=0,d=20){\n";
  output += "  if ( d > 0 && dist <800 ) {\n";
  output += "    sinVal=0.422618261740699;\n";
  output += "    deltaDist= .1;\n";
  output += "    dist1= dist-deltaDist;\n";
  output += "\n";
  output += "    rotate( [0,90,i] )\n";
  output += "       translate([0,0,dist1])\n";
  output += "            cylinder(d1=sinVal*dist1,d2=sinVal*dist,h=deltaDist);\n";
  output += "    }\n";
  output += "}\n";
  output += "\n";
  output += "\n";
  server.sendContent(output);
  server.chunkedResponseFinalize();
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
  int y = 0;
  int x = 0;

  //  for ( int i = SERVO_POS_MIN ; i <= SERVO_POS_MAX; i += SERVO_INCREMENT) {
  for ( int i = 0 ; i <= SERVO_POS_MAX; i += 1 ) {
    int y2 = result[i];
    int x2 = i;
    //    int x2 = i * SERVO_TO_DEGREE;
    sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, 140 - y, x2, 140 - y2);
    out += temp;
    y = y2;
    x = x2;
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
  if ( ACTIVATE_WEBSERVER ) {
    server.on("/", handleRoot);
    server.on("/distGraph.svg", drawGraph);
    server.on("/result.scad", handleScad);
    server.on("/roomLayout.svg", drawRoomLayout);
    server.on("/get", handleGet);
    server.onNotFound(handleNotFound);
    server.begin();
  }
  Serial.println("HTTP server started");
}


void loop() {

  VL53L0X_RangingMeasurementData_t measure;

  // Serial.print("Reading a measurement... ");
  lox.rangingTest(&measure, false); // pass in 'true' to get debug data printout!

  if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    float dist_cm = measure.RangeMilliMeter / 10.0;
    printStatus(servoPos, dist_cm);
    if ( dist_cm > 800) {
      result[servoPos] = -1;
    } else {
      result[servoPos] = dist_cm;
    }
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
  }
  if ( servoPos < SERVO_POS_MIN ) {
    servoPos = SERVO_POS_MIN;
    servoIncrement = SERVO_INCREMENT;
  }

  myservo.write(servoPos );
  delay(0);

  if (ACTIVATE_WEBSERVER) {
    server.handleClient();
    MDNS.update();
  }
}
