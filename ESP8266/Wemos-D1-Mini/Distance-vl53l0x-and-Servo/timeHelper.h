#ifndef _TIME_HELPER
#define _TIME_HELPER

// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin


// -----------------------------------------------------------
// Libraries for Time handling and NTP(Network time protocoll)
#include <time.h>                       // time() ctime()         1)
#include <sys/time.h>                   // struct timeval
#include <TZ.h>

#include "Arduino.h" // For String

String upTimeString();
String dateTimeString();
void initTimeHelper();


#endif
