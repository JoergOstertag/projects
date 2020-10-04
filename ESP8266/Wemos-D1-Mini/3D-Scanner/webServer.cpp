#include "webServer.h"
#include "config.h"

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

#include "htmlFormHandler.h"
#include "resultStorageHandler.h"

#include "positioner.h"
#include "timeHelper.h"
#include "getDistance.h"

#include "sdCardWrite.h"

#define SIZE_2D_GRAPH 600

ESP8266WebServer server(80);

extern unsigned int currentResultArrayIndex;

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
  Serial.print("Get File ... ");
  for (int i = 0; i < server.args(); i++) {

    Serial.print("Arg nº" + (String)i + " – > ");
    Serial.print(server.argName(i) + ": ");
    Serial.print( server.arg(i) + "\n");
  }
  //deliverSdCardFile("test.txt");

  Serial.println("DONE");
}

bool handleParameters() {
  bool changes = false;
  changes |= parseParameter(server, "servoPosAzMin",    resultStorageHandler.servoPosAzMin);
  changes |= parseParameter(server, "servoPosAzMax",    resultStorageHandler.servoPosAzMax);
  changes |= parseParameter(server, "servoStepAz",      resultStorageHandler.servoStepAz);

  if ( !servoStepActive) {
    // parseParameter(server, "servoPosEl",    position.az );
    // parseParameter(server, "servoPosAz",    position.el );
  }
  changes |= parseParameter(server, "servoPosElMin",    resultStorageHandler.servoPosElMin);
  changes |= parseParameter(server, "servoPosElMax",    resultStorageHandler.servoPosElMax);
  changes |= parseParameter(server, "servoStepEl",      resultStorageHandler.servoStepEl);


  parseParameter(server, "servoStepActive", servoStepActive);
  parseParameter(server, "preMeasureDelay", preMeasureDelay);
  parseParameter(server, "distanceMaxRetry", distanceMaxRetry);
  parseParameter(server, "distanceNumAveraging", distanceNumAveraging);

  parseParameter(server, "debugPosition", debugPosition);
  parseParameter(server, "debugDistance", debugDistance);
  parseParameter(server, "debugResultPosition", resultStorageHandler.debugResultPosition);

  return changes;
}


void deliverDistanceGraph() {
  Serial.print("distanceGraph ... ");

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

  for ( int i = 0; i < resultStorageHandler.maxValidIndex(); i++) {
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
  Serial.println("DONE");
}





void deliverRoomLayoutHtml() {
  Serial.print("deliverRoomLayoutHtml ... ");

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer

  server.send(200, "text/html", F("<html>\n"
                                  "<head>\n"
                                  "  <meta http-equiv='refresh' content='20'/>\n"
                                  "</head>\n"
                                  "<body>\n"));

  server.sendContent(
    // Uptime
    upTimeString() + "<br/>\n"

    // Show Scan percentage
    + "Scan: " + String(currentResultArrayIndex * 100 / resultStorageHandler.maxIndex() ) + " %<br/>\n"

    "<a href=\"roomLayout.html\">Room Layout:</a><br/>\n"

    "    <img src=\"/roomLayout.svg\" />\n"
    "</body>\n"
    "</html>\n"
    "\n");

  server.chunkedResponseFinalize();
  Serial.println("DONE");

}

void handleRoot() {
  Serial.print("handleRoot ... ");

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "text/html", F("<html>\n"
                                  "<head>\n"
                                  "  <title>3D Scanner</title>\n"
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
                                  "  <h3><a href=\"/\">ESP8266 3D-Scanner</a></h3>\n"


                                  "\n"));

  {
    String output ;
    output.reserve(2000);
    output += F("   <div style=\"class:roomLayout; float:left; width:100%; margin:8px;\">\n");
    {
      // Room Layout img Reference
      output += "\n";
      output += "      <div style=\"float:left; height:" + String( SIZE_2D_GRAPH + 90 ) + "; width:" + String(SIZE_2D_GRAPH + 20) + "\">\n";
      output += "          <iframe height=" + String( SIZE_2D_GRAPH + 60) + " width=" + String(SIZE_2D_GRAPH + 20) + " frameBorder=\"0\"  hspace=\"0\" vspace=\"0\" marginheight=\"0\" \"\n";
      output += "          src=\"/roomLayout.html\" />\n";
      output += "          </iframe>\n";
      output += "      </div>\n";
    }

    {
      output += "  <div style=\"text-align:left; margin:8px;\">\n";

      // Link to Documentation
      output +=  F("<a href=\"https://github.com/JoergOstertag/projects/blob/master/ESP8266/Wemos-D1-Mini/3D-Scanner/README.md\"  target=\"_blank\">"
                   "Documentation"
                   "</a><br/>\n");

      // Open Scad Reference
      output += F("      <a href=\"/scan-3D.scad\" target=\"_blank\">scan-3D.scad</a><br/>\n\n");

      // CSV Reference
      output += F("      <a href=\"/scan.csv\"  target=\"_blank\">scan.csv</a><br/>\n\n");

      // /distanceGraph.svg
      output += F("      <a href=\"/distanceGraph.svg\"  target=\"_blank\">distanceGraph.svg</a><br/>\n\n");

      output += "   </div>\n\n";
    }
    server.sendContent(output); output = "";

    {
      // HTML Forms
      //output += "      <div style=\"text-align:right; margin: 8px;\">\n";
      output += F("   <iframe height=600 width=400 src=\"inputForm.html\" />\n");
      //output +=           inputForm();
      //output += "      </div>\n\n";
    }

    output += F("    </div>\n"
                "\n");
    server.sendContent(output);
  }



  // Distances Graf img reference

  server.sendContent(F( "\n"
                        "       <div style=\"float:left; margin:8px;\">\n"
                        "          <p>Distances:<p/>\n"
                        "          <img src=\"/deliverDistanceGraph.svg\" />\n"
                        "       </div>\n"
                        "\n"
                        // html End
                        "\n\n"
                        "  </body>\n"
                        "</html > \n"));

  server.chunkedResponseFinalize();
  Serial.println("DONE");

}

void handleStartNewScan() {
  Serial.print("handleStartNewScan ... ");
  currentResultArrayIndex = 0;
  resultStorageHandler.resetResults();
  servoStepActive = true;
  server.send(200, "text/html", "<html>New Scan started</html>");
}

/**
   Separate Frame for input FOrm
*/
void handleInputForm() {
  Serial.print("handleInputForm ... ");

  if (   handleParameters()) {
    resultStorageHandler.resetResults();
  }

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "text/html", "");
  server.sendContent(F("<html>\n"
                       "<head>\n"
                       "  <title><a href=\"/\">Parameters</a></title>\n"
                       "  <style>\n"
                       "    body {\n"
                       "     background-color: #cccccc;\n"
                       "     font-family: Arial, Helvetica, Sans-Serif;\n"
                       "     Color: #000088;\n"
                       "     }\n"
                       "  </style>\n"
                       "</head>\n\n"
                       "\n"
                       "<body>\n"
                       "\n"
                       " <div style=\"text-align:right; margin: 8px;\">\n"));

  // border: 1px solid green;
  server.sendContent(F("   <div style=\"text-align:left; margin:8px; \">\n"
                       "   <a href=\"/inputForm.html\">Parameters:</a>\n"
                       "     <form action=\"/inputForm.html\">\n"));

  server.sendContent("      <table>\n");
  server.sendContent( formString("servoPosAzMin",        resultStorageHandler.servoPosAzMin));
  server.sendContent( formString("servoPosAzMax",        resultStorageHandler.servoPosAzMax));
  server.sendContent( formString("servoStepAz",          resultStorageHandler.servoStepAz));

  server.sendContent( F("         <tr><td><br></td></tr>\n" ));
  server.sendContent( formString("servoPosElMin",        resultStorageHandler.servoPosElMin));
  server.sendContent( formString("servoPosElMax",        resultStorageHandler.servoPosElMax));
  server.sendContent( formString("servoStepEl",          resultStorageHandler.servoStepEl));

  PolarCoordinate maxPosition = resultStorageHandler.getPosition(resultStorageHandler.maxValidIndex());

  server.sendContent( F("         <tr><td><br></td></tr>\n" ));
  server.sendContent( formString("servoStepActive",      servoStepActive));
  if (!servoStepActive) {
    //server.sendContent( formString("servoPosAz",         position.az));
    //server.sendContent( formString("servoPosEl",         position.el));
  }
  server.sendContent( F("         <tr><td><br></td></tr>\n" ));
  server.sendContent( formString("preMeasureDelay",      preMeasureDelay));
  server.sendContent( formString("distanceMaxRetry",     distanceMaxRetry));
  server.sendContent( formString("distanceNumAveraging", distanceNumAveraging));

  server.sendContent( F("         <tr><td><br></td></tr>\n" ));
  server.sendContent( formString("debugDistance",        debugDistance));
  server.sendContent( formString("debugPosition",        debugPosition));
  server.sendContent( formString("debugResultPosition",  resultStorageHandler.debugResultPosition ));

  if ( false ) {
    server.sendContent( F("    <div class=\"slidecontainer\"> \n\n"
                          "          <input type=\"range\" min=\"1\" max=\"100\" value=\"50\" class=\"slider\" id=\"myRange\">\n\n"
                          "    </div>\n\n"));
  }

  server.sendContent( F( "        </table>\n"
                         "      <input type=\"submit\" value=\"Submit\">\n"
                         "     </form><br>\n"

                         "<br/>"
                         " <a href=\"/startNewScan\" target=\"command\"> start New Clean Scan</a><br/>"
                         " <a href=\"/writeToSdCardCsv.cgi\"  target=\"command\"> write csv to SD Card</a><br/>"));

  server.sendContent( F( "   <table>\n"));
  server.sendContent( "         <tr><td>Max Elevation: </td><td>El: " + String(maxPosition.el)  + " , Az: " + String(maxPosition.az) + "</td></tr>\n");
  server.sendContent( "         <tr><td>servoNumPointsAz: </td><td>" + String( resultStorageHandler.servoNumPointsAz()) + "</td></tr>\n");
  server.sendContent( "         <tr><td>servoNumPointsEl: </td><td>" + String(resultStorageHandler.servoNumPointsEl()) + "</td></tr>\n");
  server.sendContent( "         <tr><td>maxIndex: </td><td>" + String(resultStorageHandler.maxIndex()) + "</td></tr>\n");
  server.sendContent( "         <tr><td>maxValidIndex: </td><td>" + String(resultStorageHandler.maxValidIndex()) + "</td></tr>\n");
  server.sendContent( "         <tr><td>maxAvailableArrayIndex: </td><td>" + String(resultStorageHandler.maxAvailableArrayIndex) + "</td></tr>\n");
  server.sendContent( F( "  </table>\n"));
  
  server.sendContent( F( "    </div>\n\n"
                      "   </div>\n\n"
                      " </body>\n\n"
                      "</html>\n"));
  server.chunkedResponseFinalize();


  Serial.println("DONE");
  server.send(200, "text/html", "<html>CSV Write done</html>");
}


/**
   Send Data as CSV
*/
void deliverCSV() {
  Serial.print("deliverCSV ... ");

  String filename = "scan-3D.csv";

  server.sendHeader("Content-Disposition", "attachment; filename=" + filename);

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "text/csv", F("az;el;distance\n"));

  String output;
  output.reserve(2000);

  for ( int i = 0; i < resultStorageHandler.maxValidIndex(); i++) {
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
  Serial.println("DONE");
}


/**
   Send Open Scad File to Server connection
*/
void deliverScad() {
  Serial.print(F("deliverScad ... "));

  String filename = "scan-3D.scad";
  server.sendHeader("Content-Disposition", "attachment; filename=" + filename);

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "application/x-openscad",
              F(
                "// ===========================================================\n"
                "// 3D-Scan with Distance Sensor\n"
                "// ===========================================================\n"
                "fov= "));
  server.sendContent( String(distanceFov));
  server.sendContent( F(";\n"
                        "\n"
                        "\n"
                        "\n"
                        "\n"
                       ));

  for ( int i = 0; i < resultStorageHandler.maxValidIndex(); i++) {
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
  Serial.println("DONE");
}



void deliverRoomLayoutSvg() {
  Serial.print("drawRoomLayout ... ");
  char temp[200];

  int height = SIZE_2D_GRAPH;
  int width  = SIZE_2D_GRAPH;

  server.setContentLength(CONTENT_LENGTH_UNKNOWN);   //Enable Chunked Transfer
  server.send(200, "image/svg+xml", "");

  {
    String out;
    out.reserve(2000);
    out += "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"" + String(width) + "\" height=\"" + String(height) + "\">\n";
    out += "<rect width=\"" + String(width) + "\" height=\"" + String(height) + "\" fill=\"rgb(50, 230, 210)\" stroke-width=\"1\" stroke=\"rgb(0, 0, 0)\" />\n";
    out += "<g stroke=\"black\">\n";
    server.sendContent(out);
  }
  int maxVal = resultStorageHandler.resultMax();

  float grad2Rad = 71.0 / 4068.0;
  int y = -1;
  int x = -1;
  int countValidPoints = 0;
  for ( int i = 0; i < resultStorageHandler.maxValidIndex(); i++) {
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
      server.sendContent(temp);

      // Draw lines between points
      if ( el > resultStorageHandler.servoPosAzMin) {
        if ( az > 0 && x >= 0 && y >= 0 && x2 >= 0 && y2 >= 0) {
          sprintf(temp, "<line x1=\"%d\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke-width=\"1\" />\n", x, y, x2, y2);
          server.sendContent(temp);
        }
      }

      y = y2;
      x = x2;
    }

  }

  { // white centered Coordinate Lines (x and y)
    sprintf(temp, "<line x1=\"%d\" y1=\"0\" x2=\"%d\" y2=\"%d\" stroke=\"white\" stroke-width=\"1\" />\n", width / 2, width / 2, height);
    server.sendContent(temp);
    sprintf(temp, "<line x1=\"0\" y1=\"%d\" x2=\"%d\" y2=\"%d\" stroke=\"white\" stroke-width=\"1\" />\n", height / 2, width, height / 2);
    server.sendContent(temp);
  }

  {
    String out;
    out.reserve(200);
    out = "<text x=\"0\" y=\"15\" fill=\"blue\">max Dist: ";
    out += maxVal;
    out += "</text>\n";

    out += "<text x=\"0\" y=\"35\" fill=\"blue\">ValidPoints: ";
    out += countValidPoints;
    out += "</text>\n";


    server.sendContent(out);
  }

  {
    server.sendContent(F("</g>\n</svg>\n"));
  }

  server.sendContent("");
  server.chunkedResponseFinalize();
  Serial.println("DONE");
}


void handleWriteToSdCardCsv() {
  Serial.println("handleWriteToSdCardCsv");
  sdCardWriteCSV(resultStorageHandler);
  server.send(200, "image/svg+xml", "<html>Writing to SD Card Done</html>");
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
  Serial.print("initWebserver ... ");
  resultStorageHandler = newResultStorageHandler;
  if ( ACTIVATE_WEBSERVER ) {
    server.serveStatic("/favicon.png", SPIFFS, "/favicon.png");
    server.on("/", handleRoot);
    server.on("/distanceGraph.svg", deliverDistanceGraph);
    server.on("/scan-3D.scad", deliverScad);
    server.on("/scan.csv", deliverCSV);
    server.on("/roomLayout.svg", deliverRoomLayoutSvg);
    server.on("/roomLayout.html", deliverRoomLayoutHtml);
    server.on("/inputForm.html", handleInputForm);
    server.on("/file", handleFile);
    server.on("/writeToSdCardCsv.cgi", handleWriteToSdCardCsv);
    server.on("/startNewScan", handleStartNewScan);
    server.onNotFound(handleNotFound);
    server.begin();
  }
  Serial.println("HTTP server started");

}
