#include "htmlFormHandler.h"

bool formDebug = true;


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


String formString(String name, int value) {
  String output = "";
  output += "          <tr><td>" + name + ": </td><td><input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\"></td></tr>\n";

  return output;
}

bool parseParameter(ESP8266WebServer &server, String name, int &value ) {
  String parameterString = server.arg(name);
  if (parameterString != "") {
    int newValue = parameterString.toInt();
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



String formString(String name, bool value) {
  if (formDebug) {
    Serial.print("formString(");
    Serial.print(name);
    Serial.print("): ");
    Serial.println(value);
  }
  String output = "          "
                  "<tr><td>"
                  "<label for = \""
                  + name
                  + "\">" + name + "</label>"
                  + ": </td><td>"

                  // <INPUT type="radio" name="sex" value="Male"> Male<BR>
                  // <INPUT type="radio" name="sex" value="Female"> Female<BR>
                  + " <input type=\"radio\" id=\"" + name + "\" name=\"" + name + "\" value=\"ON\" " + ( value ? " checked " : " " ) + " > ON\n"
                  + " <input type=\"radio\" id=\"" + name + "\" name=\"" + name + "\" value=\"OFF\" " + ( !value ? " checked " : " " ) + " > OFF\n"
                  + "</td></tr>\n";
  return output;
}

bool parseParameter(ESP8266WebServer & server, String name, bool & value ) {
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


String formString(String name, float value) {
  String output = "";
  output += "          <tr><td>" + name + ": </td><td><input type=\"text\" name=\"" + name + "\" value=\"";
  output += value;
  output += "\"></td></tr>\n";

  return output;
}
