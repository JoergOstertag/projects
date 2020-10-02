#ifndef _HTML_FORM_HANDLER_H
#define _HTML_FORM_HANDLER_H

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

// Interrims import
#include "resultStorageHandler.h"

bool parseParameter(ESP8266WebServer &server, String name, int &value );
bool parseParameter(ESP8266WebServer &server, String name, float &value );

String formString(String name, int value);
String formString(String name, float value);

#endif // _HTML_FORM_HANDLER_H
