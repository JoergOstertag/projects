/* Sweep
  by BARRAGAN <http://barraganstudio.com>
  This example code is in the public domain.

  modified 8 Nov 2013
  by Scott Fitzgerald
  http://www.arduino.cc/en/Tutorial/Sweep
*/

#include <Servo.h>

#define LASER_PIN 6
#define LASER_ON HIGH
#define LASER_OFF LOW


#define posMin 100
#define posMax 180

int servoPositions[] = {
//  0, 7, 2, 4, 9, 3
  0, 4, 5, 6, 9, 10
};
int posCount = 6;

Servo myServo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int oldPos=0;

void setup() {
  myServo.attach(5);  // attaches the servo on Pos 9 to the servo object

  pinMode(LASER_PIN, OUTPUT);

  digitalWrite(LASER_PIN, LASER_OFF);
  sweep();

}


void sweep() {
  myServo.write(posMin);              // tell servo to go to position in variable 'pos'
  delay(15);                       // waits 15ms for the servo to reach the position
  myServo.write(posMax);              // tell servo to go to position in variable 'pos'
  delay(15);                       // waits 15ms for the servo to reach the position
}

void loop() {


  for (int thisPos = posCount - 1; thisPos >= 0; thisPos--) {
    // turn the pos on:
    int thisVal = servoPositions[thisPos];
    
    digitalWrite(LASER_PIN, LASER_OFF);
    
    myServo.write(posMin - thisVal);
    
    int deltaPos=oldPos-thisVal;
    int delayTime=abs(deltaPos);
    delay(delayTime*20);
    
    digitalWrite(LASER_PIN, LASER_ON);
    
    delay(55);
    oldPos=thisVal;
  }
  
  //delay(200);

}


