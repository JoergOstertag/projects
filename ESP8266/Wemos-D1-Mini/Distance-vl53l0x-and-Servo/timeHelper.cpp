#include "timeHelper.h"

String upTimeString() {
  char temp[100];
  int sec = millis() / 1000;
  int min = sec / 60;
  int hr = min / 60;

  snprintf(temp, 100, "Uptime: %02d:%02d:%02d ", hr, min % 60, sec % 60 );
  String result = String(temp);
  return result;
}


void debugCurrentTime() {

  time_t now = time(nullptr);
  String time = String(ctime(&now));
  Serial.print( time);
}

String dateTimeString() {
  timeval tv;
  gettimeofday(&tv, NULL);

  time_t tnow = tv.tv_sec;
  struct tm *ti;
  ti = localtime(&tnow);

  char timeStringBuff[50];
  strftime(timeStringBuff, sizeof(timeStringBuff), "%Y-%b-%d_%H-%M-%S", ti);
  return String(timeStringBuff);
}


void initTimeHelper() {
  // Set timezone to get the resulting time as local time (not as GMT)
  configTime(MYTZ, "pool.ntp.org");
}
