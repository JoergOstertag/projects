#include "wifi.h"

#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager


ESP_WiFiManager ESP_wifiManager("ESP_Configuration");


// Wifimanager Timeout for initial connection
int connectTimeout = 20; // in seconds

// wait this time before we retry to connect (in ms)
unsigned long reconnectInterval = 1000 * 60 * 2; // 1 Minute

// Wifimanager Timeout for reconnects
int reconnectTimeout = 4; // in seconds
  

void initWifiWithWifimanager() {
  String ssid = "ESP_" + String(ESP_getChipId(), HEX);
  Serial.print(F("Wifi Manager ..."));
  ESP_wifiManager.setDebugOutput(true);
  ESP_wifiManager.setTimeout(connectTimeout);
  Serial.print(F("   (timeout="));
  Serial.print(connectTimeout);
  Serial.print(" sec. )");
  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  Serial.print(F("   ... autoconnect ... "));
  ESP_wifiManager.autoConnect();
  Serial.println();
  Serial.print(F("SSID: "));        Serial.println(WiFi.SSID());
  Serial.print(F("IP address: "));  Serial.println(WiFi.localIP());
}


/**
    Check current WiFi Status and reconnect if necessary
*/
wl_status_t prevStatus;
unsigned long lastConnectTry = 0;
void checkWifiStatus(void) {
  
  if (WiFi.status() != prevStatus) {
    Serial.print("Wifi State changed to ");
    Serial.println(ESP_wifiManager.getStatus(WiFi.status()));
    prevStatus = WiFi.status();
    if ( WiFi.isConnected() ) {
      Serial.print("Local IP: ");  Serial.println(WiFi.localIP());
      Serial.print("SSID: ");      Serial.println(WiFi.SSID());
    }
  }

  if (!WiFi.isConnected()) {
    if ( lastConnectTry + reconnectInterval < millis()) {
      Serial.print(F("Try reconnecting ... "));

      ESP_wifiManager.setTimeout(reconnectTimeout);
      Serial.print(F("   (timeout="));
      Serial.print(reconnectTimeout);
      Serial.print(F(" sec. ) ..."));

      ESP_wifiManager.autoConnect();
      if ( WiFi.isConnected() ) {
        Serial.println(F("reconnected"));
        Serial.print(F("Local IP: "));  Serial.println(WiFi.localIP());
        Serial.print(F("SSID: "));      Serial.println(WiFi.SSID());
      } else {
        Serial.println(F(" !!! NO connection"));
      }
      lastConnectTry = millis();
    }

  }
}
