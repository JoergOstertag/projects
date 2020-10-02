#ifndef _RESULT_STORAGE_HANDLER_H
#define _RESULT_STORAGE_HANDLER_H

#include "config.h"

//#include "Arduino.h"

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



    bool debugResultPosition = true;

    float servoPosAzMin =   0;
    float servoPosAzMax = 180;
    float servoStepAz   =   2;

    float servoPosElMin =   0;
    float servoPosElMax =  90;
    float servoStepEl   =   1;

    PolarCoordinate getPosition(unsigned int resultArrayIndex);
    int getResult(unsigned int resultArrayIndex);
    void putResult(unsigned int resultArrayIndex, int value);
    unsigned int indexOfPosition( PolarCoordinate  currentPosition );
    unsigned int nextPositionLinear( unsigned int resultArrayIndex );
    unsigned int nextPositionServo( unsigned int resultArrayIndex );
    unsigned int maxIndex();
    unsigned int servoNumPointsAz();
    unsigned int servoNumPointsEl();
    bool checkPosition(unsigned int resultArrayIndex);
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
