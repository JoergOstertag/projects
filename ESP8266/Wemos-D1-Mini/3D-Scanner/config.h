// ----------------------------------
// SD Card
#define USE_SD_CARD

// ----------------------------------
// Servos

// External Board attached over I2C
#define SERVO_PCA

// Pins for Servos in PWA direct Pin Version
#ifndef SERVO_PCA
// Use CPU-Pins PIN_SERVO_AZ and PIN_SERVO_EL defined below
#define SERVO_PWM
#endif

// For PWM configuration of Servo. Pins at the CPU Board
#define PIN_SERVO_AZ D3
#define PIN_SERVO_EL D4

// ----------------------------------
// Distance Sensor
// #define USE_DISTANCE_VL53L0X
#define USE_DISTANCE_LIDAR_LITE
// s#define USE_DISTANCE_HCSR04

/**
   Result storage Handler
*/
// ----------------------------------
// Web Server
#define ACTIVATE_WEBSERVER true


// Set M-DNS to this name. This resuls in being see at URL similar to 
// http://<MDNS_NAME>.fritz.box/
// http://3d-scanner.fritz.box/
#define MDNS_NAME F("3D-SCANNER")
