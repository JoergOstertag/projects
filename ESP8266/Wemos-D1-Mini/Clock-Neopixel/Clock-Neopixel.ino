/****************************************************************************************************************************

  Get the time with ntp and display the time on a neopixel Ring

  Wifi Setup is derived from Example AutoConnect.ino using library https://github.com/khoih-prog/ESP_WiFiManager

  To configure Wifi on the device:
   - connect to an AP called ESP_XXXXXXX
   - enter http://192.168.4.1/ into browser and configure the AP and pwd

 *****************************************************************************************************************************/

// -----------------------------------------------------------
// Libs for Wifi Connection
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>

#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager


// -----------------------------------------------------------
// Libraries for Time handling and NTP(Network time protocoll)
#include <time.h>                       // time() ctime()         1)
#include <sys/time.h>                   // struct timeval
#include <TZ.h>

// -----------------------------------------------------------
// Lib for Neopixel Ring
#include <Adafruit_NeoPixel.h>


// Define Wifimanager
ESP_WiFiManager ESP_wifiManager("ESP_Configuration");

// Define Neo Pixel Ring
#define NUM_PIXELS    24
#define NEOPIXEL_PIN  D4

Adafruit_NeoPixel pixels(NUM_PIXELS, D4, NEO_GRB | NEO_KHZ800);

// Define LED color for hour,minute,second
int intens = 100;
uint32_t colorBackground = pixels.Color(0, 0, 0);
uint32_t colorMinute   = pixels.Color(0, 0, intens);
uint32_t colorHour     = pixels.Color(0, intens, 0);
uint32_t colorSecond   = pixels.Color(intens, intens, 0);


// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin

/**
   set all Neopixels to Background Color
*/
void clearPixel() {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, colorBackground);
  }
}

/**
   Shows the time on the Neo Pixel Ring
*/
void showTime() {
  clearPixel();
  int i;

  time_t tnow;
  struct tm *ti;

  tnow = time(nullptr) + 1;
  ti = localtime(&tnow);

  // Hour
  int h = ti->tm_hour;
  if ( h > 12 ) h -= 12;
  i = h * NUM_PIXELS / 12;
  Serial.printf("Hour=%i ", i);
  pixels.setPixelColor(i, colorHour);

  // Minute
  i = ti->tm_min * NUM_PIXELS / 60;
  Serial.printf("Min=%i ", i);
  pixels.setPixelColor(i, colorMinute);

  // Seconds
  i = ti->tm_sec * NUM_PIXELS / 60;
  Serial.printf("Sec=%i ", i);
  pixels.setPixelColor(i, colorSecond);
  
  Serial.println();

  // Send pixels to display
  pixels.show();
  
  delay(20);
}


/**
 *  Check current WiFi Status and reconnect if necessary
 */
wl_status_t prevStatus;
void checkWifiStatus(void) {

  if (WiFi.status() != prevStatus) {
    Serial.print("Wifi State changed to ");
    Serial.println(ESP_wifiManager.getStatus(WiFi.status()));
    prevStatus = WiFi.status();
    if ( WiFi.isConnected() ) {
      Serial.print("Local IP: ");  Serial.println(WiFi.localIP());
      Serial.print("SSID: ");      Serial.println(WiFi.SSID());
    }
  }

  if (!WiFi.isConnected()) {
    ESP_wifiManager.autoConnect();
  }
}



void setup() {
  Serial.begin(115200);
  Serial.println("\n");
  Serial.println("Starting ESP Neo Pixel Clock ... ");

  ESP_wifiManager.setDebugOutput(true);

  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  ESP_wifiManager.autoConnect();

  // Set timezone to get the resulting time as local time (not as GMT)
  configTime(MYTZ, "pool.ntp.org");

  // Initialize Neopixel Ring
  pixels.begin();

}

void loop() {
  checkWifiStatus();


  // Get current Time and Print it on Serial
  time_t now = time(nullptr);
  String time = String(ctime(&now));
  Serial.print( time);

  // SHow time on Neopixel Ring
  showTime();

  // Wait a little bit, so we do not flood the console
  delay(1.0 * 1000);
}
