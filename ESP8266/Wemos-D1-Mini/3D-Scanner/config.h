// ----------------------------------
// SD Card
#define USE_SD_CARD

// ----------------------------------
// Servos

#define SERVO_PCA

// Pins for Servos in PWA direct Pin Version
#ifndef SERVO_PCA
#define SERVO_PWM
#endif

#ifdef SERVO_PWM
#define PIN_SERVO_AZ D3
#define PIN_SERVO_EL D4
#endif

// ----------------------------------
// Distance Sensor
// #define USE_DISTANCE_VL53L0X
#define USE_DISTANCE_LIDAR_LITE
// #define USE_DISTANCE_HCSR04

/**
   Result storage Handler
*/
// ----------------------------------
// Web Server
#define ACTIVATE_WEBSERVER true
