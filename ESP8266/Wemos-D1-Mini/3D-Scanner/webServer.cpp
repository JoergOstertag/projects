#include "config.h"
#include "webServer.h"

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include "sdCardWrite.h"
#include "SdFat.h"

#include "htmlFormHandler.h"
#include "webServer.h"
#include "resultStorageHandler.h"
#include "positioner.h"
#include "timeHelper.h"
#include "getDistance.h"

#include "sdCardWrite.h"

#define SIZE_2D_GRAPH 600

//SdFat SD;
//File myFile;


ESP8266WebServer server(80);

extern unsigned int resultArrayIndex;

extern ResultStorageHandler resultStorageHandler;

/**
  void deliverSdCardFile(String fileName) {

  myFile = SD.open(fileName);
  if (myFile) {
    Serial.print("Check " + fileName + "\n");
    server.streamFile(myFile, "text/plain");
    // close the file:
    myFile.close();
  } else {
    // if the file didn't open, print an error:
    Serial.println("error opening test.txt");
  }


  server.chunkedResponseFinalize();
  }
*/

void handleFile() {
  for (int i = 0; i < server.args(); i++) {

    Serial.print("Arg nº" + (String)i + " – > ");
    Serial.print(server.argName(i) + ": ");
    Serial.print( server.arg(i) + "\n");
  }
  //deliverSdCardFile("test.txt");

}

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
  parseParameter(server, "distanceMaxRetry", distanceMaxRetry);

  return changes;
}


void distanceGraph() {

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "image/svg+xml", "");


  char temp[100];
  int width = 900;
  int height = 300;

  {
    String out;
    out.reserve(1000);
    out = "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"";
    out += String(width) + "\" height=\"" + String( height) + "\">\n";

    out += "<rect width=\"" + String(width) + "\" height=\"" + String(height) + "\" fill=\"rgb(250, 230, 210)\" stroke-width=\"1\" stroke=\"rgb(0, 0, 0)\" />\n";
    out += "<g stroke=\"black\">\n";

    server.sendContent(out);
  }

  int y = 0;
  int x = 0;
  int maxVal = 10 + resultStorageHandler.resultMax();

  for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
    PolarCoordinate position = resultStorageHandler.getPosition(i);
    int el = position.el;
    int az = position .az;
    int y2 = resultStorageHandler.getResult(i) * height / maxVal;
    if ( y2 > 0 ) {
      int x2 = (az - resultStorageHandler.servoPosAzMin ) * width / (resultStorageHandler.servoPosAzMax - resultStorageHandler.servoPosAzMin);
      if ( y > 0) {
        if ( az > resultStorageHandler.servoPosAzMin ) {
          sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, height - y, x2, height - y2);
        }
        server.sendContent(temp);

      }
      y = y2;
      x = x2;
    }
  }
  server.sendContent(F("</g>\n"
                       "</svg>\n"));

  server.chunkedResponseFinalize();
}



String inputForms() {
  String output ;
  output.reserve(2000);
  output = "\n";

  // border: 1px solid green;
  output += "<div style=\"text-align:left; margin:8px; \">\n";
  output += "Parameters:\n";
  output += "<form action=\"/\">\n";

  output += "       <table>\n";
  // output += formString("servoPosAz",       servoPosAz);
  output += formString("servoPosAzMin",       resultStorageHandler.servoPosAzMin);
  output += formString("servoPosAzMax",       resultStorageHandler.servoPosAzMax);
  output += formString("servoStepAz",         resultStorageHandler.servoStepAz);
  output += formString("servoOffsetAZ",       servoOffsetAZ);

  output += "       <tr><td><br></td></tr>\n";
  //  output += formString("servoPosEl",       servoPosEl);
  output += formString("servoPosElMin",       resultStorageHandler.servoPosElMin);
  output += formString("servoPosElMax",       resultStorageHandler.servoPosElMax);
  output += formString("servoStepEl",         resultStorageHandler.servoStepEl);
  output += formString("servoOffsetEL",       servoOffsetEL);


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

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer

  server.send(200, "text/html", F("<html>\n"
                                  "<head>\n"
                                  "  <meta http-equiv='refresh' content='20'/>\n"
                                  "  <title>ESP8266 Distance</title>\n"
                                  "  <style>\n"
                                  "    body {\n"
                                  "     background-color: #cccccc;\n"
                                  "     font-family: Arial, Helvetica, Sans-Serif;\n"
                                  "     Color: #000088;\n"
                                  "     }\n"
                                  "  </style>\n"
                                  "</head>\n"
                                  "\n"
                                  "<body>\n"
                                  "\n"
                                  "  <h3>ESP8266 3D-Scanner</h3>\n"
                                  "\n"));



  {
    String output ;
    output.reserve(2000);
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

      // Show Scan percentage
      output += "      <p>Scan: " + String(resultArrayIndex * 100 / resultStorageHandler.maxIndex() ) + " %</p>\n";

      // Open Scad Reference
      output += "      <p><a href=\"/scan-3D.scad\">scan-3D.scad</a></p>\n\n";
      // CSV Reference
      output += "      <p><a href=\"/scan.csv\">scan.csv</a></p>\n\n";
      output += "   </div>\n\n";
    }
    server.sendContent(output); output = "";

    {
      // HTML Forms
      output += "      <div style=\"text-align:right; margin: 8px;\">\n";
      // output += "   <iframe height=600 width=400 src=\"inputForm.html\" />\n";
      output +=           inputForms();
      output += "      </div>\n\n";
    }

    output += "    </div>\n";
    output += "\n";
    server.sendContent(output);
  }



  // Distances Graf img reference

  server.sendContent(F( "\n"
                        "       <div style=\"float:left; margin:8px;\">\n"
                        "          <p>Distances:<p/>\n"
                        "          <img src=\"/distanceGraph.svg\" />\n"
                        "       </div>\n"
                        "\n"
                        // html End
                        "\n\n"
                        "  </body>\n"
                        "</html > \n"));

  server.chunkedResponseFinalize();

}

/**
   Separate Frame for input FOrm
*/
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


/**
   Send Data as CSV
*/
void handleCSV() {

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "text/csv", F("az;el;distance\n"));

  String output;
  output.reserve(2000);

  for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
    PolarCoordinate position = resultStorageHandler.getPosition(i);

    output = position.az;
    output += ";";
    output += position.el;
    output += ";";
    output += resultStorageHandler.getResult(i);
    output += "\n";

    server.sendContent(output);
  }
  server.chunkedResponseFinalize();
}


/**
   Send Open Scad File to Server connection
*/
void handleScad() {

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "text/plain", F(
                "// ===========================================================\n"
                "// 3D-Scan with Distance Sensor\n"
                "// ===========================================================\n"
                "fov=20;\n"
                "\n"
                "\n"
                "\n"
                "\n"
              ));

  for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
    PolarCoordinate position = resultStorageHandler.getPosition(i);

    String output;
    output = "segment(";
    output += "az=";
    output += position.az;
    output += ",\t";

    output += "el=";
    output += position.el;
    output += ",\t";

    output += "dist=";
    output += resultStorageHandler.getResult(i);
    output += ");\n";

    server.sendContent(output);
  }

  server.sendContent( F("\n"
                        "\n"
                        "\n"
                        "module segment(az=0,el=0,dist=20){\n"
                        "if ( dist > 0 ) {\n"
                        "    tanFactor=tan(fov);\n"
                        "    deltaDist= .1;\n"
                        "    dist1= dist-deltaDist;\n"
                        "\n"
                        "      rotate( [el,0,-az] )\n"
                        "        rotate( [-90,0,0] )\n"
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

    int dist = resultStorageHandler.getResult(i);
    if (  dist > 0 ) {
      countValidPoints++;
      float rad = grad2Rad * az;
      float distFloor = dist * cos(grad2Rad * el);
      float distPixel = distFloor * max(height, width) / maxVal / 2;
      int y2 = (width / 2)  - cos(rad) * distPixel;
      int x2 = (height / 2) + sin(rad) * distPixel;

      // Draw circle at endpoints
      sprintf(temp, "  <circle cx=\"%d\" cy=\"%d\" r=\"2\" fill=\"red\" />\n", x2, y2);
      out += temp;

      // Draw lines between points
      if ( el > resultStorageHandler.servoPosAzMin) {
        if ( az > 0 && x >= 0 && y >= 0 && x2 >= 0 && y2 >= 0) {
          sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, y, x2, y2);
          out += temp;
        }
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
    out = "<text x=\"0\" y=\"15\" fill=\"blue\">max Dist: ";
    out += maxVal;
    out += "</text>\n";

    out += "<text x=\"0\" y=\"35\" fill=\"blue\">ValidPoints: ";
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


void writeToSdCard() {
  sdCardWrite(resultStorageHandler);
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



void serverHandleClient() {
  server.handleClient();
}

void initWebserver(ResultStorageHandler &newResultStorageHandler) {  // Register URLs to answer
  resultStorageHandler = newResultStorageHandler;
  if ( ACTIVATE_WEBSERVER ) {
    server.on("/", handleRoot);
    server.on("/distanceGraph.svg", distanceGraph);
    server.on("/scan-3D.scad", handleScad);
    server.on("/scan.csv", handleCSV);
    server.on("/roomLayout.svg", drawRoomLayout);
    server.on("/inputForm.html", handleInputForm);
    server.on("/writeToSdCard.cgi", writeToSdCard);
    server.on("/file", handleFile);
    server.onNotFound(handleNotFound);
    server.begin();
  }
  Serial.println("HTTP server started");

}
