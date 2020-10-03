#include "resultStorageHandler.h"
#include <stdlib.h>
#include <Arduino.h>


ResultStorageHandler::ResultStorageHandler() {
}
/**

*/
bool ResultStorageHandler::checkPosition(long currentResultArrayIndex) {
  if (currentResultArrayIndex >= maxAvailableArrayIndex) {
    Serial.print("Result Array Index ( ");
    Serial.print(currentResultArrayIndex);
    Serial.print(" ) out of bound. maxAvailableArrayIndex=");
    Serial.print(maxAvailableArrayIndex);
    Serial.println();
    return false;
  }
  if (currentResultArrayIndex < 0 ) {
    Serial.print("Result Array Index ( ");
    Serial.print(currentResultArrayIndex);
    Serial.print(" ) out of bound. Negative");
    Serial.println();
    return false;
  }

  if (currentResultArrayIndex >= maxIndex() ) {
    Serial.print("Result Array Index ( ");
    Serial.print(currentResultArrayIndex);
    Serial.print(" ) too large. maxIndex=");
    Serial.print(maxIndex());
    Serial.println();
    return false;
  }

  if (currentResultArrayIndex >= maxValidIndex() ) {
    Serial.print("Result Array Index ( ");
    Serial.print(currentResultArrayIndex);
    Serial.print(" ) too large. maxValidIndex=");
    Serial.print(maxValidIndex());
    Serial.println();
    return false;
  }

  return true;
}

/**

*/
void ResultStorageHandler::debugPosition( long currentResultArrayIndex) {
  PolarCoordinate position = ResultStorageHandler::getPosition(currentResultArrayIndex);
  if ( debugResultPosition) {
    Serial.printf( " ArrayPos: %5u", currentResultArrayIndex);
    Serial.printf( " AZ: %4d", (int)position.az );
    Serial.printf( " EL: %4d", (int)position.el );
  }
}


/**

*/
PolarCoordinate ResultStorageHandler::getPosition(long  currentResultArrayIndex) {

  checkPosition(currentResultArrayIndex);

  PolarCoordinate resultCoordinate;
  unsigned int elIndex = currentResultArrayIndex / servoNumPointsAz();
  // Serial.print(" elIndex: ");  Serial.print(elIndex );

  resultCoordinate.el = servoPosElMin + elIndex * servoStepEl;

  unsigned int azIndex = currentResultArrayIndex - (elIndex * servoNumPointsAz());
  // Serial.print(" azIndex: ");  Serial.print(azIndex );

  resultCoordinate.az = servoPosAzMin + (azIndex * servoStepAz);

  return resultCoordinate;
}

/**

*/
int ResultStorageHandler::getResult(long currentResultArrayIndex) {
  if ( !  checkPosition(currentResultArrayIndex)) {
    return -2;
  }

  return _result[currentResultArrayIndex];
}

/**

*/
void ResultStorageHandler::putResult(long  currentResultArrayIndex, int value) {
  if ( ! checkPosition(currentResultArrayIndex) ) {
    return;
  }
  _result[currentResultArrayIndex] = value;
};

/**

*/
long ResultStorageHandler::indexOfPosition( PolarCoordinate  currentPosition ) {
  long indexAz = (currentPosition.az - servoPosAzMin ) / servoStepAz;
  long result = ( ( currentPosition.el - servoPosElMin ) /  servoStepEl ) + indexAz;
  return result;
}

long ResultStorageHandler::maxIndex() {
  long result = servoNumPointsEl() * servoNumPointsAz();
  return result;

}

long ResultStorageHandler::maxValidIndex() {
  long result = servoNumPointsEl() * servoNumPointsAz();
  result = min(maxAvailableArrayIndex, result);
  return result;
}


long  ResultStorageHandler::servoNumPointsAz() {
  long result = abs(servoPosAzMax - servoPosAzMin) / servoStepAz + 1;
  return result ;
}

long ResultStorageHandler::servoNumPointsEl() {
  long result = abs(servoPosElMax - servoPosElMin) / servoStepEl + 1;
  return result;
}



/**
    Get next position with the smallest movement. So the servo is not moving unnecessary positions
    XXX: Here we have to get the height and with of the scan area an iterate by changing the az-direction forward and backward.
*/
long ResultStorageHandler::nextPositionServo( long currentResultArrayIndex) {
  currentResultArrayIndex  += 1;
  if (currentResultArrayIndex >= maxAvailableArrayIndex) {
    return 0;
  }
  if (currentResultArrayIndex >= maxIndex() ) {
    return 0;
  }
  return currentResultArrayIndex;
}


/**
   Get next position array wise
*/
long ResultStorageHandler::nextPositionLinear( long currentResultArrayIndex ) {
  currentResultArrayIndex += 1;
  if (currentResultArrayIndex >= maxAvailableArrayIndex) {
    return 0;
  }
  if (currentResultArrayIndex >= maxIndex() ) {
    return 0;
  }
  return currentResultArrayIndex;
}



int ResultStorageHandler::resultMax() {
  int max = 0;
  for ( unsigned int i = 0; i < maxValidIndex(); i++ ) {
    int dist = _result[i];
    if ( dist > max) {
      max = dist;
    }
  }

  return max;
}

void ResultStorageHandler::resetResults() {
  Serial.println("Reset Results ...");
  for ( long i = 0; i < maxAvailableArrayIndex; i++) {
    _result[i] = -1;
  }
}

void ResultStorageHandler::initResults() {
  Serial.println("Init Results Array ...");
  uint32_t freeHeap = ESP.getFreeHeap();
  maxAvailableArrayIndex = (freeHeap - 8 * 1024) / sizeof(short);
  if (maxAvailableArrayIndex >= 0) {
    _result = (short*) malloc( sizeof(short) * (maxAvailableArrayIndex + 1));
    if (!_result){
      Serial.println("Cannot allocate Memory");
      maxAvailableArrayIndex=0;
    }
  } else {
    Serial.println("Cannot allocate Memory");
  }
}
