#include "htmlFormHandler.h"

bool formDebug = false;


bool parseParameter(ESP8266WebServer &server, String name, float &value ) {
  String parameterString = server.arg(name);
  if (parameterString != "") {
    float newValue = parameterString.toFloat();
    if ( newValue != value ) {
      Serial.print("parameterString(");
      Serial.print(name);
      Serial.print("): changed '");
      Serial.print(value);
      Serial.print("' => '");
      Serial.print(newValue);
      Serial.println("'");
      value = newValue;
      return true;
    }
  }
  return false;
}


String formString(String prefix, String name, int value, String postfix ) {
  String output = prefix + "\n";
  output += "          <td><input title=\"" + name + "\" type=\"text\" name=\"" + name + "\" size=\"6\" value=\"";
  output += value;
  output += "\"></td>\n";
  output +=  postfix;

  return output;
}

bool parseParameter(ESP8266WebServer &server, String name, int &value ) {
  String parameterString = server.arg(name);
  if (parameterString != "") {
    int newValue = parameterString.toInt();
    if ( newValue != value) {
      Serial.print("parameterString(");
      Serial.print(name);
      Serial.print("): changed '");
      Serial.print(value);
      Serial.print("' => '");
      Serial.print(newValue);
      Serial.println("'");
      value = newValue;
      return true;
    }
  }
  return false;
}



String formString(String prefix, String name, bool value, String postfix ) {
  if (formDebug) {
    Serial.print("formString(");
    Serial.print(name);
    Serial.print("): ");
    Serial.println(value);
  }
  String output = prefix + "\n          "
                  "<td>"
                  " <label for = \""
                  + name
                  + "\">" + name + "</label>"
                  + ": </td> <td>"
                  + " <input type=\"radio\" id=\"" + name + "\" name=\"" + name + "\" value=\"ON\" " + ( value ? " checked " : " " ) + " > ON\n"
                  + " <input type=\"radio\" id=\"" + name + "\" name=\"" + name + "\" value=\"OFF\" " + ( !value ? " checked " : " " ) + " > OFF\n"
                  + "</td>\n"
                  + postfix;
  return output;
}

bool parseParameter(ESP8266WebServer &server, String name, bool & value ) {
  if (server.hasArg(name)) {
    String parameterString = server.arg(name);
    if (formDebug) {
      Serial.print("parameterString(");
      Serial.print(name);
      Serial.print("): ");
      Serial.println(parameterString);
    }
    bool newValue = false;
    if (parameterString == "ON") {
      newValue = true;
    }
    if ( newValue != value ) {
      Serial.print("parameterString(");
      Serial.print(name);
      Serial.print("): changed '");
      Serial.print(value);
      Serial.print("' => '");
      Serial.print(newValue);
      Serial.println("'");
      value = newValue;
      return true;
    }
  } else {
    if (formDebug) {
      Serial.print("parameterString(");
      Serial.print(name);
      Serial.println("): missing");
    }
  }

  return false;
}


String formString(String prefix, String name, float value, String postfix ) {
  String output = prefix + "\n";
  output += "          <td><input title=\"" + name + "\" type=\"text\" name=\"" + name + "\" size=\"6\" value=\"";
  output += value;
  output += "\"></td>\n";
  output += postfix;

  return output;
}
