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

    bool debugResultPosition = false;

    long maxAvailableArrayIndex = 1;

    float servoPosAzMin = -90;
    float servoPosAzMax =  90;
    float servoStepAz   =   2;

    float servoPosElMin = -170;
    float servoPosElMax =  -10;
    float servoStepEl   =   2;

    PolarCoordinate getPosition(long currentResultArrayIndex);
    int getResult(long currentResultArrayIndex);
    void putResult(long  currentResultArrayIndex, int value);
    long indexOfPosition( PolarCoordinate  currentPosition );
    long nextPositionLinear( long currentResultArrayIndex );
    long nextPositionServo( long currentResultArrayIndex );
    long maxIndex();
    long maxValidIndex();
    long servoNumPointsAz();
    long servoNumPointsEl();
    bool checkPosition(long currentResultArrayIndex);
    void debugPosition( long currentResultArrayIndex);

    int resultMax();
    void initResults();

    void resetResults();



  private:
    /**
       Result Values in mm
       nagative values are invalid/out of range
    */
    short *_result;

};

#endif
