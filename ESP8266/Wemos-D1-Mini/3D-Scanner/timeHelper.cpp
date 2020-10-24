#include "timeHelper.h"

// Date and time functions using a DS1307 RTC connected via I2C and Wire lib
#include "RTClib.h"
#include <TimeLib.h>

RTC_DS1307 rtc;

char daysOfTheWeek[7][12] = {"Sun", "Mon", "Tue", "Wedn", "Thu", "Fri", "Sat"};


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
void showRtcTime() {

  DateTime now = rtc.now();

  Serial.print(now.year(), DEC);
  Serial.print('/');
  Serial.print(now.month(), DEC);
  Serial.print('/');
  Serial.print(now.day(), DEC);
  Serial.print(" (");
  Serial.print(daysOfTheWeek[now.dayOfTheWeek()]);
  Serial.print(") ");
  Serial.print(now.hour(), DEC);
  Serial.print(':');
  Serial.print(now.minute(), DEC);
  Serial.print(':');
  Serial.print(now.second(), DEC);
  Serial.println();

}
String dateTimeString2() {
  DateTime now = rtc.now();

  // char timeStringBuff[50];
  // sprintf(timeStringBuff, "%d-%d-%d_%s_%d-%d-%d",          (int)now.year(),          (int)now.month(),          (int)now.day(),          daysOfTheWeek[now.dayOfTheWeek()],          (int)now.hour(),          (int)now.minute(),          (int)now.second());
  //return String(timeStringBuff);
  return  String((int)now.year()) + "-"
          + String((int)now.month()) + "-"
          + String((int)now.day()) + "_"
          + String(daysOfTheWeek[now.dayOfTheWeek()]) + "_"
          + String((int)now.hour()) + "-"
          + String((int)now.minute()) + "-"
          + String((int)now.second());

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
  Serial.println("");
  Serial.println("Initialize Time Helper ...");

  // Set timezone to get the resulting time as local time (not as GMT)
  configTime(MYTZ, "pool.ntp.org");

  // configure rtc DS1307
  if (! rtc.begin()) {
    Serial.println("Couldn't find RTC");
    Serial.flush();
   // abort();
  }

  if (! rtc.isrunning()) {
    Serial.println("RTC is NOT running, let's set the time!");
    // When time needs to be set on a new device, or after a power loss, the
    // following line sets the RTC to the date & time this sketch was compiled
    Serial.println("sets the RTC to the date & time this sketch was compiled");
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
    // This line sets the RTC with an explicit date & time, for example to set
    // January 21, 2014 at 3am you would call:
    // rtc.adjust(DateTime(2014, 1, 21, 3, 0, 0));
  } else {
    Serial.println("RTC is running.");
  }




  // cannot find getNtpTime()
  //  rtc.adjust(getNtpTime());


  // When time needs to be re-set on a previously configured device, the
  // following line
  if (false) {
    Serial.println("sets the RTC to the date & time this sketch was compiled");
    // rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
    rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));
  }
  // This line sets the RTC with an explicit date & time, for example to set

  Serial.print("showRtcTime():"); showRtcTime();
  Serial.println();
  if (false) {
    Serial.println("Set hard to ... January 21, 2014 at 3am you would call:");
    // January 21, 2014 at 3am you would call:
    rtc.adjust(DateTime(2014, 1, 21, 3, 0, 0));
    // rtc.adjust(DateTime(2020, 10, 21, 15, 45, 0));
  }

  timeval tv;
  gettimeofday(&tv, NULL);
  if ( year() > 2000 ) {
    Serial.println("set the system time to xxx");
    setTime(hour(), minute(), second(), day(), month(), year());   //set the system time to 23h31m30s on 13Feb2009
    //rtc.adjust(DateTime(tv.tv_year, tv.tv_month, tv.tv_day, tv.tv_hour, tv.tv_min, tv.tv_sec));
  }


  Serial.println();
  Serial.print("showRtcTime():"); showRtcTime();
  Serial.print("dateTimeString():"); Serial.println(dateTimeString());
  Serial.print("dateTimeString2():"); Serial.println(dateTimeString2());
  Serial.println();
}
