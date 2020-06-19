#include "htmlFormHandler.h"

boolean parseParameter(ESP8266WebServer &server, String name, int &value ) {
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

boolean parseParameter(ESP8266WebServer &server, String name, float &value ) {
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
  String output = "     <form action=\"/\">\n";
  output += "      " + name + ": <input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\">\n";
  output += "       <input type=\"submit\" value=\"Submit\">\n";
  output += "     </form><br>\n";

  return output;
}

String formString(String name, float value) {
  String output = "     <form action=\"/\">\n";
  output += "      " + name + ": <input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\">\n";
  output += "       <input type=\"submit\" value=\"Submit\">\n";
  output += "     </form><br>\n";

  return output;
}
