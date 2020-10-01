#include "resultStorageHandler.h"

ResultStorageHandler::ResultStorageHandler() {
  _result = (short*) malloc( sizeof(short) * (MAX_RESULT_INDEX + 1));

  if ( false ) {
    servoPosAzMin = -10;
    servoPosAzMax =  10;
    servoStepAz   =   1;

    servoPosElMin =  1;
    servoPosElMax =  2;
    servoStepEl   =   3;

    debugResultPosition=true;
  }
}

boolean ResultStorageHandler::checkPosition(unsigned int resultArrayIndex) {
  if (resultArrayIndex >= MAX_RESULT_INDEX) {
    Serial.print("Result Array Index ( ");
    Serial.print(resultArrayIndex);
    Serial.print(" ) out of bound. MAX_RESULT_INDEX=");
    Serial.print(MAX_RESULT_INDEX);
    Serial.println();
    return false;
  }

  if (resultArrayIndex >= maxIndex() ) {
    Serial.print("Result Array Index ( ");
    Serial.print(resultArrayIndex);
    Serial.print(" ) too large. servoNumPoints=");
    Serial.print(maxIndex());
    Serial.println();
    return false;
  }

  return true;
}

void ResultStorageHandler::debugPosition( unsigned int resultArrayIndex) {
  PolarCoordinate position = ResultStorageHandler::getPosition(resultArrayIndex);
  if ( debugResultPosition) {
    Serial.printf( " ArrayPos: %5u", resultArrayIndex);
    Serial.printf( " AZ: %4d", (int)position.az );
    Serial.printf( " EL: %4d", (int)position.el );
  }
}

PolarCoordinate ResultStorageHandler::getPosition(unsigned int resultArrayIndex) {

  checkPosition(resultArrayIndex);

  PolarCoordinate resultCoordinate;
  unsigned int elIndex = resultArrayIndex / servoNumPointsAz();
  // Serial.print(" elIndex: ");  Serial.print(elIndex );

  resultCoordinate.el = servoPosElMin + elIndex * servoStepEl;

  unsigned int azIndex = resultArrayIndex - (elIndex * servoNumPointsAz());
  // Serial.print(" azIndex: ");  Serial.print(azIndex );

  resultCoordinate.az = servoPosAzMin + (azIndex * servoStepAz);

  return resultCoordinate;
}

int ResultStorageHandler::getResult(unsigned int resultArrayIndex) {
  if ( !  checkPosition(resultArrayIndex)) {
    return -2;
  }

  return _result[resultArrayIndex];
}

void ResultStorageHandler::putResult(unsigned int resultArrayIndex, int value) {
  if ( ! checkPosition(resultArrayIndex) ) {
    return;
  }
  _result[resultArrayIndex] = value;
};

unsigned int ResultStorageHandler::indexOfPosition( PolarCoordinate  currentPosition ) {

}

unsigned int ResultStorageHandler::maxIndex() {
  unsigned int result = servoNumPointsEl() * servoNumPointsAz();
  return result;

}


unsigned int ResultStorageHandler::servoNumPointsAz() {
  unsigned int result = (servoPosAzMax - servoPosAzMin) / servoStepAz+1;
  return result ;
}

unsigned int ResultStorageHandler::servoNumPointsEl() {
  unsigned int result = (servoPosElMax - servoPosElMin) / servoStepEl+1;
  return result;
}



/**
    Get next position with the smallest movement. So the servo is not moving unnecessary positions
    XXX: Here we have to get the height and with of the scan area an iterate by changing the az-direction forward and backward.
*/
unsigned int ResultStorageHandler::nextPositionServo( unsigned int resultArrayIndex) {
  resultArrayIndex  += 1;
  if (resultArrayIndex >= MAX_RESULT_INDEX) {
    return 0;
  }
  if (resultArrayIndex >= maxIndex() ) {
    return 0;
  }
  return resultArrayIndex;
}


/**
   Get next position array wise
*/
unsigned int ResultStorageHandler::nextPositionLinear( unsigned int resultArrayIndex ) {
  resultArrayIndex += 1;
  if (resultArrayIndex >= MAX_RESULT_INDEX) {
    return 0;
  }
  if (resultArrayIndex >= maxIndex() ) {
    return 0;
  }
  return resultArrayIndex;
}


void ResultStorageHandler::resetResults() {
  for ( int i = 0; i < MAX_RESULT_INDEX; i++) {
    _result[i] = -1;
  }
}

int ResultStorageHandler::resultMax() {
  int max = 0;
  for ( unsigned int i = 0; i < maxIndex(); i++ ) {
    int dist = _result[i];
    if ( dist > max) {
      max = dist;
    }
  }

  return max;

}
