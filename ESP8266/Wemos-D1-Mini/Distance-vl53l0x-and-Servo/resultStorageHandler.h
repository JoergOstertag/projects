#ifndef _RESULT_STORAGE_HANDLER_H
#define _RESULT_STORAGE_HANDLER_H

#include "Arduino.h"

/**
   Result storage Handler
*/

#define MAX_RESULT_INDEX 5000

/**
   polar Coordinate
*/
struct polarCoordinate {
  float az;
  float el;
};


class ResultStorageHandler {
  public:
    ResultStorageHandler();


    int servoPosAzMin =  00;
    int servoPosAzMax = 180;
    int servoStepAz   =  10;

    int servoPosElMin =  80;
    int servoPosElMax = 110;
    int servoStepEl   =  10;

    polarCoordinate getPosition(unsigned int resultArrayIndex);
    int getResult(unsigned int resultArrayIndex);
    void putResult(unsigned int resultArrayIndex, int value);
    unsigned int indexOfPosition( polarCoordinate  currentPosition );
    unsigned int nextPositionLinear( unsigned int resultArrayIndex );
    unsigned int nextPositionServo( unsigned int resultArrayIndex );
    unsigned int maxIndex();
    unsigned int servoNumPointsAz();
    unsigned int servoNumPointsEl();
    boolean checkPosition(unsigned int resultArrayIndex);

    int resultMax();

    void resetResults();



  private:

    /**
       Result Values in mm
       nagative values are invalid/out of range
    */
    int _result[MAX_RESULT_INDEX];


};

#endif
