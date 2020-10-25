#ifndef _HTML_FORM_HANDLER_H
#define _HTML_FORM_HANDLER_H

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

// Interrims import
#include "resultStorageHandler.h"

bool parseParameter(ESP8266WebServer &server, String name, int &value   );
bool parseParameter(ESP8266WebServer &server, String name, float &value );
bool parseParameter(ESP8266WebServer &server, String name, bool &value  );

String formString(String prefix, String name, int value,    String postfix);
String formString(String prefix, String name, float value,  String postfix);
String formString(String prefix, String name, bool value,   String postfix);

#endif // _HTML_FORM_HANDLER_H
