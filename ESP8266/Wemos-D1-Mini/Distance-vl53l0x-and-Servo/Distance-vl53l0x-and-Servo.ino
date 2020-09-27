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


  TODO:
  - adapt fov=20 to real value of sensor
  - put fov automatically into the resulting scad fi
  - Add sin() to calculation of distance and 2D-SVG
  - use separate iframes so the refreash not always reinjects the html Values (even after recompile)
  - use seperate Sourcode Files
  - Check Memory usage for larger Scans (Maybe use seperate I2C RAM or SD-Card
  - refactor az/el calculation to have a loop over arrayindex (prevent rounding errors in index calculation)
**/

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

#include "htmlFormHandler.h"
#include "getDistance.h"
#include "webServer.h"
#include "resultStorageHandler.h"
#include "positioner.h"

ResultStorageHandler resultStorageHandler;

ESP_WiFiManager ESP_wifiManager("ESP_Configuration");

// Correction for Servo Direction and Position
int servoDirectionAZ = -1;
int servoDirectionEL = -1;
int servoOffsetAZ = -90;
int servoOffsetEL = -90;

int preMeasureDelay = 20;

unsigned int resultArrayIndex = 0;

#define DIST_MIN 1
#define DIST_MAX 500*10


#define SIZE_2D_GRAPH 600



#define ACTIVATE_WEBSERVER true

ESP8266WebServer server(80);


boolean handleParameters() {
  boolean changes = false;
  if ( servoStepActive == 0) {
    //    changes |= parseParameter(server, "servoPosEl",    servoPosEl );
  }
  changes |= parseParameter(server, "servoPosAzMin",    resultStorageHandler.servoPosAzMin);
  changes |= parseParameter(server, "servoPosAzMax",    resultStorageHandler.servoPosAzMax);
  changes |= parseParameter(server, "servoStepAz",      resultStorageHandler.servoStepAz);
  parseParameter(server, "servoOffsetAZ", servoOffsetAZ);

  if ( servoStepActive == 0) {
    //  changes |= parseParameter(server, "servoPosAz",    servoPosAz );
  }
  changes |= parseParameter(server, "servoPosElMin",    resultStorageHandler.servoPosElMin);
  changes |= parseParameter(server, "servoPosElMax",    resultStorageHandler.servoPosElMax);
  changes |= parseParameter(server, "servoStepEl",      resultStorageHandler.servoStepEl);
  parseParameter(server, "servoOffsetEL", servoOffsetEL);


  parseParameter(server, "servoStepActive", servoStepActive);
  parseParameter(server, "preMeasureDelay", preMeasureDelay);
  parseParameter(server, "distanceMaxRetry",distanceMaxRetry);

  return changes;
}

void drawRoomLayout() {
  String out;
  out.reserve(200);
  char temp[70];

  int height = SIZE_2D_GRAPH;
  int width  = SIZE_2D_GRAPH;

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "image/svg+xml", "");

  out += "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"" + String(width) + "\" height=\"" + String(height) + "\">\n";
  out += "<rect width=\"" + String(width) + "\" height=\"" + String(height) + "\" fill=\"rgb(50, 230, 210)\" stroke-width=\"1\" stroke=\"rgb(0, 0, 0)\" />\n";
  out += "<g stroke=\"black\">\n";


  server.sendContent(out);

  int maxVal = resultStorageHandler.resultMax();

  float grad2Rad = 71.0 / 4068.0;
  int y = -1;
  int x = -1;
  int countValidPoints = 0;
  for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
    out = "";
    PolarCoordinate position = resultStorageHandler.getPosition(i);
    int el = position.el;
    int az = position .az;
    if ( el <= resultStorageHandler.servoPosAzMin) {
      y = -1;
      x = -1;
    }

    int elCorrected = (el + servoOffsetEL) * servoDirectionEL;
    int azCorrected = (az + servoOffsetAZ) * servoDirectionAZ;
    int dist = resultStorageHandler.getResult(i);
    if (  dist > 0 ) {
      countValidPoints++;
      float rad = grad2Rad * azCorrected;
      float distFloor = dist * cos(grad2Rad * elCorrected);
      float distPixel = distFloor * max(height, width) / maxVal / 2;
      int y2 = (width / 2)  + sin(rad) * distPixel;
      int x2 = (height / 2) + cos(rad) * distPixel;

      // Draw circle at endpoints
      sprintf(temp, "  <circle cx=\"%d\" cy=\"%d\" r=\"2\" fill=\"red\" />\n", x2, y2);
      out += temp;

      // Draw lines between points
      if ( az > 0 && x >= 0 && y >= 0 && x2 >= 0 && y2 >= 0) {
        sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, y, x2, y2);
        out += temp;
      }
      y = y2;
      x = x2;
      server.sendContent(out);
    }

  }

  { // white centered Coordinate Lines (x and y)
    out = "<line x1=\"" + String(width / 2) + "\" y1=\"0\" x2=\"" + String(width / 2) + "\" y2=\"" + String(height) + "\" stroke=\"white\" stroke-width=\"1\" />\n";
    out += "<line x1=\"0\" y1=\"" + String(height / 2) + "\" x2=\"" + String(width) + "\" y2=\"" + String(height / 2) + "\" stroke=\"white\" stroke-width=\"1\" />\n";
    server.sendContent(out);
  }

  {
    out = "<text x=\"0\" y=\"15\" fill=\"blue\">maxVal: ";
    out += maxVal;
    out += "</text>\n";

    out += "<text x=\"0\" y=\"30\" fill=\"blue\">ValidPoints: ";
    out += countValidPoints;
    out += "</text>\n";


    server.sendContent(out);
  }

  {
    out = "</g>\n</svg>\n";
    server.sendContent(out);
  }

  server.sendContent("");
  server.chunkedResponseFinalize();
}



void distanceGraph() {

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "image/svg+xml", "");


  String out;
  out.reserve(2600);
  char temp[70];
  int width = 900;
  int height = 300;

  out += "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"";
  out += String(width) + "\" height=\"" + String( height) + "\">\n";

  out += "<rect width=\"" + String(width) + "\" height=\"" + String(height) + "\" fill=\"rgb(250, 230, 210)\" stroke-width=\"1\" stroke=\"rgb(0, 0, 0)\" />\n";
  out += "<g stroke=\"black\">\n";

  server.sendContent(out);


  int y = 0;
  int x = 0;
  int maxVal = 10 + resultStorageHandler.resultMax();

  for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
    PolarCoordinate position = resultStorageHandler.getPosition(i);
    int el = position.el;
    int az = position .az;
    int y2 = resultStorageHandler.getResult(i) * height / maxVal;
    if ( y2 < DIST_MAX && y2 > 0 ) {
      int x2 = (az - resultStorageHandler.servoPosAzMin ) * width / (resultStorageHandler.servoPosAzMax - resultStorageHandler.servoPosAzMin);
      if ( y > 0) {
        if ( az > resultStorageHandler.servoPosAzMin ) {
          sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, height - y, x2, height - y2);
        }
        out = temp;
        server.sendContent(out);

      }
      y = y2;
      x = x2;
    }
  }
  server.sendContent(F("</g>\n"
                       "</svg>\n"));

  server.sendContent("");
  server.chunkedResponseFinalize();
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

String inputForms() {
  String output = "\n";

  // border: 1px solid green;
  output += "<div style=\"text-align:left; margin:8px; \">\n";
  output += "Parameters:\n";
  output += "<form action=\"/\">\n";

  output += "       <table>\n";
  // output += formString("servoPosAz",       servoPosAz);
  output += formString("servoPosAzMin",       resultStorageHandler.servoPosAzMin);
  output += formString("servoPosAzMax",       resultStorageHandler.servoPosAzMax);
  output += formString("servoStepAz",         resultStorageHandler.servoStepAz);
  output += formString("servoOffsetAZ", servoOffsetAZ);

  output += "       <tr><td><br></td></tr>\n";
  //  output += formString("servoPosEl",       servoPosEl);
  output += formString("servoPosElMin",       resultStorageHandler.servoPosElMin);
  output += formString("servoPosElMax",       resultStorageHandler.servoPosElMax);
  output += formString("servoStepEl",         resultStorageHandler.servoStepEl);
  output += "       <tr><td><br></td></tr>\n";
  output += formString("servoOffsetEL", servoOffsetEL);
  output += "       <tr><td><br></td></tr>\n";
  output += formString("servoStepActive",         servoStepActive);
  output += "       <tr><td><br></td></tr>\n";
  output += formString("preMeasureDelay",         preMeasureDelay);
  output += formString("distanceMaxRetry", distanceMaxRetry);

  if ( false) {
    output += "    <div class=\"slidecontainer\"> \n\n";
    output += "          <input type=\"range\" min=\"1\" max=\"100\" value=\"50\" class=\"slider\" id=\"myRange\">\n\n";
    output += "    </div>\n\n";
  }

  output += "       </table>\n";
  output += "       <input type=\"submit\" value=\"Submit\">\n";
  output += "     </form><br>\n";
  output += "   </div>\n\n";

  return output;

}


void handleRoot() {

  if (   handleParameters()) {
    resultStorageHandler.resetResults();
  }

  String output = "<html>\n\
  <head>\n\
    <meta http-equiv='refresh' content='5'/>\n\
    <title>ESP8266 Distance</title>\n\
    <style>\n\
      body {\n\
       background-color: #cccccc;\n\
       font-family: Arial, Helvetica, Sans-Serif;\n\
       Color: #000088;\n\
       }\n\
    </style>\n\
  </head>\n\n";

  output += "  <body>\n";
  output += "\n";
  output += "  <h2>ESP8266 3D-Scanner</h2>\n\n";



  {
    output += "   <div style=\"float:left; width:100%; margin:8px;\">\n";
    {
      // Room Layout img Reference
      output += "\n";
      output += "      <div style=\"float:left; height:" + String( SIZE_2D_GRAPH + 40 ) + "; width:" + String(SIZE_2D_GRAPH ) + "\">\n";
      output += "          <p>Room Layout:</p>\n";
      output += "          <img src=\"/roomLayout.svg\" />\n";
      output += "      </div>\n";
    }

    {
      output += "  <div style=\"text-align:left; margin:8px;\">\n";

      // Uptime
      output += "      <p>" + upTimeString() + "</p>\n";

      // Open Scad Reference
      output += "      <p>\n";
      output += "         <a href=\"/scan-3D.scad\">scan-3D.scad</a>\n";
      output += "      </p>\n\n";
      output += "   </div>\n\n";
    }

    {
      // HTML Forms
      output += "      <div style=\"text-align:right; margin: 8px;\">\n";
      // output += "   <iframe height=600 width=400 src=\"inputForm.html\" />\n";
      output +=           inputForms();
      output += "      </div>\n\n";
    }

    output += "    </div>\n";
    output += "\n";
  }

  // Distances Graf img reference
  output += "\n";
  output += "       <div style=\"float:left; margin:8px;\">\n";
  output += "          <p>Distances:<p/>\n";
  output += "          <img src=\"/distanceGraph.svg\" />\n";
  output += "       </div>\n";
  output += "\n";

  // html End
  output += "\n\n";
  output += "  </body>\n";
  output += "</html > \n";
  server.send(200, "text/html", output);

}

void handleInputForm() {

  String output = "<html>\n\
  <head>\n\
    <title>Parameters</title>\n\
    <style>\n\
      body {\n\
       background-color: #cccccc;\n\
       font-family: Arial, Helvetica, Sans-Serif;\n\
       Color: #000088;\n\
       }\n\
    </style>\n\
  </head>\n\n";

  output += "  <body>\n";
  output += "\n";

  // HTML Forms
  output += "      <div style=\"text-align:right; margin: 8px;\">\n";
  output +=           inputForms();
  output += "      </div>\n\n";
  output += "</html > \n";
  server.send(200, "text / html", output);
}

void handleScad() {
  String output;
  output.reserve(200);

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "image/svg+xml", F(
                "\n"
                "\n"
                "\n"
                "// ===========================================================\n"
                "// Distance Sensor\n"
                "// ===========================================================\n"));

  for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
    PolarCoordinate position = resultStorageHandler.getPosition(i);
    int el = position.el;
    int az = position .az;
    int elCorrected = (el + servoOffsetEL) * servoDirectionEL;
    int azCorrected = (az + servoOffsetAZ) * servoDirectionAZ;

    output = "segment(";
    output += "az=";
    output += azCorrected;
    output += ",\t";

    output += "el=";
    output += elCorrected  ;
    output += ",\t";

    output += "dist=";
    output += resultStorageHandler.getResult(i);
    output += ");";


    // output += "// el=";
    // output += el;
    // output += ", az= ";
    // output += az;
    output += "\n";

    server.sendContent(output);
  }

  server.sendContent( F("\n"
                        "\n"
                        "\n"
                        "module segment(az=0,el=0,dist=20){\n"
                        "if ( dist > 0 ) {\n"
                        "    fov=20;\n"
                        "    tanFactor=tan(fov);\n"
                        "    deltaDist= .1;\n"
                        "    dist1= dist-deltaDist;\n"
                        "\n"
                        "      rotate( [0,el,az] )\n"
                        "        rotate( [0,-90,0] )\n"
                        "          translate([0,0,dist1])\n"
                        "            cylinder( d1= tanFactor*dist1,\n"
                        "                      d2= tanFactor*dist,\n"
                        "                       h= deltaDist );\n"
                        "    }\n"
                        "}\n"
                        "\n"
                        "\n"));
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
  Serial.println("Sent 2D Scad File");
}


void measure() {

  delay(preMeasureDelay);

  int dist_mm = getDistance(debugDistance);
  resultStorageHandler.putResult(resultArrayIndex, dist_mm);
}


void setup() {
  debugDistance = true;
  debugPosition = true;

  Serial.begin(115200);

  Serial.println();
  Serial.println("3D-Scanner .... ");


  Serial.println("Reset Results ...");
  resultStorageHandler.resetResults();

  Serial.println("Wifi Manager ...");
  ESP_wifiManager.setDebugOutput(true);

  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  ESP_wifiManager.autoConnect();
  Serial.println("");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  initPositioner();

  initDistance();

  // Make ourselfs visible with M-DNS
  if (MDNS.begin(F("3D-SCANNER"))) {
    Serial.println(F("MDNS responder started"));
    Serial.println(F("You can connect to the device with"));
    Serial.println(F("http://3d-scanner.fritz.box/"));
  }

  // Register URLs to answer
  if ( ACTIVATE_WEBSERVER ) {
    server.on("/", handleRoot);
    server.on("/distanceGraph.svg", distanceGraph);
    server.on("/scan-3D.scad", handleScad);
    server.on("/roomLayout.svg", drawRoomLayout);
    server.on("/inputForm.html", handleInputForm);

    server.onNotFound(handleNotFound);
    server.begin();
  }
  Serial.println("HTTP server started");

  Serial.print("Free Mem on Heap: ");
  Serial.print(ESP.getFreeHeap() / 1024.0, DEC);
  Serial.println(" KB");
}

void loop() {

  if (servoStepActive > 0) {
    resultArrayIndex = resultStorageHandler.nextPositionServo(resultArrayIndex);
    PolarCoordinate position = resultStorageHandler.getPosition(resultArrayIndex);

    if ( debugDistance) {
      Serial.printf( " ArrayPos: %5u", resultArrayIndex);
    }
    servo_move(position);
  }

  if ( resultArrayIndex == 0 ) {

    Serial.println();
    Serial.print(" servoNumPointsAz= " );
    Serial.print( resultStorageHandler.servoNumPointsAz() );
    Serial.print(" servoNumPointsEl= " );
    Serial.print( resultStorageHandler.servoNumPointsEl() );
    Serial.println();
    delay(1000);

  }

  measure();


  if (ACTIVATE_WEBSERVER) {
    server.handleClient();
    MDNS.update();
  }

  Serial.println();

}
