#ifndef _RESULT_STORAGE_HANDLER_H
#define _RESULT_STORAGE_HANDLER_H

#include "Arduino.h"

/**
   Result storage Handler
*/

//#define MAX_RESULT_INDEX (14*1024)

#define MAX_RESULT_INDEX (14*1024)
/**
   polar Coordinate
*/
struct PolarCoordinate {
  float az;
  float el;
};


class ResultStorageHandler {
  public:
    ResultStorageHandler();



    boolean debugResultPosition = true;

    float servoPosAzMin = -90;
    float servoPosAzMax =  90;
    float servoStepAz   =   1;

    float servoPosElMin = -10;
    float servoPosElMax =  90;
    float servoStepEl   =   4;

    PolarCoordinate getPosition(unsigned int resultArrayIndex);
    int getResult(unsigned int resultArrayIndex);
    void putResult(unsigned int resultArrayIndex, int value);
    unsigned int indexOfPosition( PolarCoordinate  currentPosition );
    unsigned int nextPositionLinear( unsigned int resultArrayIndex );
    unsigned int nextPositionServo( unsigned int resultArrayIndex );
    unsigned int maxIndex();
    unsigned int servoNumPointsAz();
    unsigned int servoNumPointsEl();
    boolean checkPosition(unsigned int resultArrayIndex);
    void debugPosition( unsigned int resultArrayIndex);

    int resultMax();

    void resetResults();



  private:

    /**
       Result Values in mm
       nagative values are invalid/out of range
    */
    // int _result[MAX_RESULT_INDEX];
    short *_result;


};

#endif
