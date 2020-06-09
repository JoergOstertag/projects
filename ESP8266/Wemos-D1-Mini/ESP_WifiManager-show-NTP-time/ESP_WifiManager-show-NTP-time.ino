/****************************************************************************************************************************
  Derived from Example AutoConnect.ino using library https://github.com/khoih-prog/ESP_WiFiManager

  To configure Wifi on the device:
   - connect to an AP called ESP_XXXXXXX
   - enter http://192.168.4.1/ into browser and configure the AP and pwd

 *****************************************************************************************************************************/

#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>

#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

ESP_WiFiManager ESP_wifiManager("ESP_Configuration");


// Libraries for Time handling and NTP(Network time protocoll)
#include <time.h>
#include <TZ.h>

// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin

void setup() {
  Serial.begin(115200);
  Serial.println("\n");
  Serial.println("Starting ESP ... ");

  ESP_wifiManager.setDebugOutput(true);

  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  ESP_wifiManager.autoConnect();

  // Set timezone to get the resulting time as local time (not as GMT) 
  configTime(MYTZ, "pool.ntp.org");
}

/**
 * Check current WiFi Status and reconnect if necessary
 * 
 */
wl_status_t prevStatus;
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
    ESP_wifiManager.autoConnect();
  }
}


void loop() {
  checkWifiStatus();


  // Get current Time and Print it
  time_t now = time(nullptr);
  String time = String(ctime(&now));
  Serial.print( time);

  // Wait a little bit, so we do not flood the console
  delay(1.0 * 1000);
}
