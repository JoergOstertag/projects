
#ifndef _HTML_FORM_HANDLER_H    
#define _HTML_FORM_HANDLER_H    

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

boolean parseParameter(ESP8266WebServer &server, String name, int &value );
boolean parseParameter(ESP8266WebServer &server, String name, float &value );

String formString(String name, int value);
String formString(String name, float value);

#endif // _HTML_FORM_HANDLER_H    // Put this line at the end of your file.
