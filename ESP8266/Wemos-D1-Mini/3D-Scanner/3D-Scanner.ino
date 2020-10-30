/**

  TODO:
  - adapt fov=20 to real value of sensor
  - put fov automatically into the resulting scad fi
  - Add sin() to calculation of in 2D-distances-SVG
  - Check Memory usage for larger Scans (Maybe use seperate I2C RAM or SD-Card
  - refactor az/el calculation to have a loop over arrayindex (prevent rounding errors in index calculation)
  - inputForm fields only take integer (not float) displayint float is working
**/


#include "getDistance.h"




#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266mDNS.h>
// #include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

#include "wifi.h"
#include "htmlFormHandler.h"
#include "webServer.h"
#include "resultStorageHandler.h"
#include "positioner.h"
#include "timeHelper.h"

#include "sdCardWrite.h"

ResultStorageHandler resultStorageHandler;

long currentResultArrayIndex = 0;

#define DIST_MIN 1
#define DIST_MAX 500*10




void measure() {

  int dist_mm = getDistance(debugDistance);
  resultStorageHandler.putResult(currentResultArrayIndex, dist_mm);
}


void showMemory() {
  uint16_t maxBlock = ESP.getMaxFreeBlockSize();
  uint32_t freeHeap = ESP.getFreeHeap();
  Serial.print("Free-Heap: "); Serial.print(freeHeap / 1024); Serial.println("KB");
  Serial.print("MaxFreeBlockSize: "); Serial.print( maxBlock / 1024); Serial.println("KB");
}



void loop() {

  checkWifiStatus();


  if (servoStepActive) {
    if ( currentResultArrayIndex == 0 ) {
      Serial.println();

      showMemory();

      Serial.println();

      Serial.print("servoNumPointsAz= " );       Serial.println( resultStorageHandler.servoNumPointsAz() );
      Serial.print("servoNumPointsEl= " );       Serial.println( resultStorageHandler.servoNumPointsEl() );
      Serial.print("maxIndex: ");                Serial.println( resultStorageHandler.maxIndex() );
      Serial.print("maxValidIndex: ");           Serial.println( resultStorageHandler.maxValidIndex() );
      Serial.print("maxAvailableArrayIndex: ");  Serial.println(resultStorageHandler.maxAvailableArrayIndex);

      if ( resultStorageHandler.maxIndex() >= resultStorageHandler.maxAvailableArrayIndex) {
        Serial.println("!!!!!! Warning maxIndex() >= maxAvailableArrayIndex !!!!!!!!");
        delay(5 * 1000);
      }

      Serial.println();
      delay(1000);

    }

    resultStorageHandler.debugPosition( currentResultArrayIndex );

  }

  measure();


  if ( currentResultArrayIndex >= (resultStorageHandler.maxValidIndex() - 1)) {
    sdCardWriteCSV(resultStorageHandler);
  }

  if (servoStepActive) {
    currentResultArrayIndex = resultStorageHandler.nextPositionServo(currentResultArrayIndex);
    PolarCoordinate position = resultStorageHandler.getPosition(currentResultArrayIndex);

    if ( debugDistance) {
      //Serial.printf( "       New ArrayPos: %5u", currentResultArrayIndex);
    }

    servo_move(position);
  }


  if (ACTIVATE_WEBSERVER) {
    serverHandleClient();
    MDNS.update();
  }

  if (debugDistance || debugPosition || resultStorageHandler.debugResultPosition) {
    if (servoStepActive) {
      Serial.println();
    }
  }

}


void setup() {

  Serial.begin(115200);
  delay(100);
  Serial.println();
  Serial.println();
  Serial.println("3D-Scanner .... ");

  initWifiWithWifimanager();

  initPositioner();

  initDistance();

  initTimeHelper();

  initSdCard();

  resultStorageHandler.initResults();
  resultStorageHandler.resetResults();

  // Make ourselfs visible with M-DNS
  if (MDNS.begin(MDNS_NAME)) {
    Serial.println(F("MDNS responder started"));
    Serial.println(F("You can connect to the device with"));
    Serial.println(F("http://3d-scanner.fritz.box/"));
  }

  initWebserver(resultStorageHandler);
}
