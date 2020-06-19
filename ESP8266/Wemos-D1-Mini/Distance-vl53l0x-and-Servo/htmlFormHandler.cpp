#include "htmlFormHandler.h"

boolean parseParameterInt(ESP8266WebServer &server, String name, int &value ) {
  String parameterString = server.arg(name);
  if (parameterString != "") {
    int newValue = parameterString.toInt();
    if ( newValue != value ) {
      value = newValue;
      return true;
    }
  }
  return false;
}

boolean parseParameterFloat(ESP8266WebServer &server, String name, float &value ) {
  String parameterString = server.arg(name);
  if (parameterString != "") {
    int newValue = parameterString.toFloat();
    if ( newValue != value ) {
      value = newValue;
      return true;
    }
  }
  return false;
}
