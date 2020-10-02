#include "htmlFormHandler.h"

bool parseParameter(ESP8266WebServer &server, String name, int &value ) {
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

bool parseParameter(ESP8266WebServer &server, String name, float &value ) {
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

String formString(String name, int value) {
  String output = "";
  output += "          <tr><td>" + name + ": </td><td><input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\"></td></tr>\n";
  
  return output;
}

String formString(String name, float value) {
  String output = "";
  output += "          <tr><td>" + name + ": </td><td><input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\"></td></tr>\n";

  return output;
}
