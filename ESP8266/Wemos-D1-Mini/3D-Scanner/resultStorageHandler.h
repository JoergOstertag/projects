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

    int maxAvailableArrayIndex = 1;

    float servoPosAzMin = -90;
    float servoPosAzMax =  90;
    float servoStepAz   =   0.5;

    float servoPosElMin =   0;
    float servoPosElMax =  60;
    float servoStepEl   =   1.5;

    PolarCoordinate getPosition(unsigned int currentResultArrayIndex);
    int getResult(unsigned int currentResultArrayIndex);
    void putResult(unsigned int currentResultArrayIndex, int value);
    unsigned int indexOfPosition( PolarCoordinate  currentPosition );
    unsigned int nextPositionLinear( unsigned int currentResultArrayIndex );
    unsigned int nextPositionServo( unsigned int currentResultArrayIndex );
    unsigned int maxIndex();
    unsigned int maxValidIndex();
    unsigned int servoNumPointsAz();
    unsigned int servoNumPointsEl();
    bool checkPosition(unsigned int currentResultArrayIndex);
    void debugPosition( unsigned int currentResultArrayIndex);

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
