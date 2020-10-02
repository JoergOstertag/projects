/**

  TODO:
  - adapt fov=20 to real value of sensor
  - put fov automatically into the resulting scad fi
  - Add sin() to calculation of in 2D-distances-SVG
  - use separate iframes so the refreash not always reinjects the html Values (even after recompile)
  - use seperate Sourcode Files
  - Check Memory usage for larger Scans (Maybe use seperate I2C RAM or SD-Card
  - refactor az/el calculation to have a loop over arrayindex (prevent rounding errors in index calculation)
**/


#include "getDistance.h"


#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

#include "htmlFormHandler.h"
#include "webServer.h"
#include "resultStorageHandler.h"
#include "positioner.h"
#include "timeHelper.h"

#include "sdCardWrite.h"

ResultStorageHandler resultStorageHandler;

ESP_WiFiManager ESP_wifiManager("ESP_Configuration");


unsigned int resultArrayIndex = 0;

#define DIST_MIN 1
#define DIST_MAX 500*10




void measure() {

  int dist_mm = getDistance(debugDistance);
  resultStorageHandler.putResult(resultArrayIndex, dist_mm);
}


void showMemory() {
  uint16_t maxBlock = ESP.getMaxFreeBlockSize();
  uint32_t freeHeap = ESP.getFreeHeap();
  Serial.print("Free-Heap: "); Serial.print(freeHeap / 1024); Serial.println("KB");
  Serial.print("MaxFreeBlockSize: "); Serial.print( maxBlock / 1024); Serial.println("KB");
}


void loop() {

  if (servoStepActive > 0) {
    if ( resultArrayIndex == 0 ) {
      Serial.println();

      showMemory();

      Serial.println();

      Serial.print("servoNumPointsAz= " );       Serial.println( resultStorageHandler.servoNumPointsAz() );
      Serial.print("servoNumPointsEl= " );       Serial.println( resultStorageHandler.servoNumPointsEl() );
      Serial.print("maxIndex: ");                Serial.println( resultStorageHandler.maxIndex() );
      Serial.print("MAX_RESULT_INDEX: ");        Serial.println(resultStorageHandler.MAX_RESULT_INDEX);

      if ( resultStorageHandler.maxIndex() >= resultStorageHandler.MAX_RESULT_INDEX) {
        Serial.println("!!!!!! Warning maxIndex() >= MAX_RESULT_INDEX !!!!!!!!");
        delay(5 * 1000);
      }

      Serial.println();
      delay(1000);

    }

    resultStorageHandler.debugPosition( resultArrayIndex);

  }

  measure();


  if ( resultArrayIndex >= (resultStorageHandler.maxIndex() - 1)) {
    sdCardWrite(resultStorageHandler);
  }

  if (servoStepActive > 0) {
    resultArrayIndex = resultStorageHandler.nextPositionServo(resultArrayIndex);
    PolarCoordinate position = resultStorageHandler.getPosition(resultArrayIndex);

    if ( debugDistance) {
      //Serial.printf( "       New ArrayPos: %5u", resultArrayIndex);
    }

    servo_move(position);
  }


  if (ACTIVATE_WEBSERVER) {
    serverHandleClient();
    MDNS.update();
  }

  Serial.println();

}



void setup() {
  debugDistance = true;
  debugPosition = true;

  Serial.begin(115200);

  Serial.println();
  Serial.println("3D-Scanner .... ");


  Serial.println("Reset Results ...");
  resultStorageHandler.resetResults();

  Serial.println("Wifi Manager ...");
  ESP_wifiManager.setDebugOutput(true);

  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  ESP_wifiManager.autoConnect();
  Serial.println("");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  initPositioner();

  initDistance();

  initTimeHelper();

  initSdCard();



  // Make ourselfs visible with M-DNS
  if (MDNS.begin(F("3D-SCANNER"))) {
    Serial.println(F("MDNS responder started"));
    Serial.println(F("You can connect to the device with"));
    Serial.println(F("http://3d-scanner.fritz.box/"));
  }

  initWebserver(resultStorageHandler);
}
