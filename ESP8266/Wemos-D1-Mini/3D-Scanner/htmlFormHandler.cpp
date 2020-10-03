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
    if ( newValue != value )
      value = newValue;
    return true;
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



String formString(String name, bool value) {
  Serial.print("formString(");
  Serial.print(name);
  Serial.print("): ");
  Serial.println(value);
  String output = "          "
                  "<tr><td>"
                  "<label for = \""
                  + name
                  + "\">" + name + "</label>"
                  + ": </td><td>"
                  + " <input "
                  + " type=\"checkbox\" "
                  + " id=\"" + name + "\" "
                  + " name=\"" + name + "\" "
                  + " value=\"" + ( value ? "ticked" : "") + "\" "
                  + ( value ? " checked " : " " )
                  + " > \n"
                  + "</td></tr>\n";
  return output;
}

bool parseParameter(ESP8266WebServer &server, String name, bool &value ) {
  if (server.hasArg(name)) {
    String parameterString = server.arg(name);
    Serial.print("parameterString(");
    Serial.print(name);
    Serial.print("): ");
    Serial.println(parameterString);
    bool newValue = false;
    if (parameterString == "ticked") {
      newValue = true;
    }
    if ( newValue != value ) {
      value = newValue;
      return true;
    }
  }

  return false;
}


String formString(String name, float value) {
  String output = "";
  output += "          <tr><td>" + name + ": </td><td><input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\"></td></tr>\n";

  return output;
}
