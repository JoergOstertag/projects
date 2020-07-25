/****************************************************************************************************************************

  Get the time with ntp and display the time on a neopixel Ring
  Vou can Specify the number of pixels in the LED Ring with NUM_PIXELS
  The variables color_hour_x,... specify the base RGB valueof the 
  
  Wifi Setup is derived from Example AutoConnect.ino using library https://github.com/khoih-prog/ESP_WiFiManager

  To configure Wifi on the device:
   - connect to an AP called ESP_XXXXXXX
   - enter http://192.168.4.1/ into browser and configure the AP and pwd

 *****************************************************************************************************************************/

// Uncomment for continuous Debug Output
// #define DEBUG

// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin

// Define Number of pixels in Neo Pixel Ring
#define NUM_PIXELS    50
// Pixel Number of the first pixel (Showing Midnight)
#define PIXEL_OFFSET  25

// Hardware Pin of Neopixel String
#define NEOPIXEL_PIN  D2

// RGB color of the LED for the hour hand
int color_hour_r = 0;
int color_hour_g = 100;
int color_hour_b = 0;

// RGB color of the LED for the minute hand
int color_min_r = 0;
int color_min_g = 0;
int color_min_b = 100;

// RGB color of the LED for the seconds hand
int color_sec_r = 100;
int color_sec_g = 100;
int color_sec_b = 0;

// The relaive intensity of all LEDs
double intens = 1.0;

// Define LED color for background
uint32_t colorBackground = pixels.Color(0, 0, 0);


// -----------------------------------------------------------
// Libs for Wifi Connection
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>

#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

// Define Wifimanager
ESP_WiFiManager ESP_wifiManager("ESP_Configuration");


// -----------------------------------------------------------
// Libraries for Time handling and NTP(Network time protocoll)
#include <time.h>                       // time() ctime()         1)
#include <sys/time.h>                   // struct timeval
#include <TZ.h>


// -----------------------------------------------------------
// Lib for Neopixel Ring
#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels(NUM_PIXELS, NEOPIXEL_PIN, NEO_GRB | NEO_KHZ800);


// Macro for debug output 
#ifdef DEBUG
 #define DEBUG_PRINTF(...)  Serial.printf (__VA_ARGS__)
#else
 #define DEBUG_PRINTF(...)
#endif



/**
   set all Neopixels to Background Color
*/
void clearPixel() {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, colorBackground);
  }
}


/**
 * Sets the pixel with the given number to the specified color.
 * If NUM_PIXEL is reached we start from the first pixel again
 * The number of the pixel set is in the range of 0 ... NUM_PIXELS-1
 * If PIXEL_OFFSET is given displaying pixels is shifted arround the circle be the amount given.
 */
void setPixelLimited(int pixel, uint32_t color){
    pixel += PIXEL_OFFSET;
    if ( pixel >= NUM_PIXELS ){
      pixel -= NUM_PIXELS;
    }
    if ( pixel >= NUM_PIXELS ){
      Serial.printf("ERROR Pixel Number (%f) too large",pixel);
      return;
    }
    pixels.setPixelColor(pixel, color);
}

/**
 * Set pixel at pixelPos to specified RGB-color
 * The number of the pixelPos is a double which is normalized between 0.0 and 1.0
 * where 0 is the first pixel. 1.0 is overflow and also the first pixel. 
 * where 1.0 -(1/NUM_PIXELS) is equivalent to the last pixel.
 * We also find out if the pixelposition is between two pixels. 
 * If we have a position inbetween two LEDs, we dim both pixels accordingly 
 * to show where inbetween the two pixels the real position is.
 * 
 */
void setFloatingPixel(double pixelPos, int red, int green , int blue){

  double pixel = pixelPos * NUM_PIXELS;
  double fractionPixel=pixel-floor(pixel);
  DEBUG_PRINTF(" Pixel(Pos: %6.4f #:%3.0f) ", pixelPos,pixel);

  // First Pixel
  double intens1 = intens*(1.0-fractionPixel);
  uint32_t color = pixels.Color(red*intens1, green*intens1, blue*intens1);
  setPixelLimited(pixel, color);
  DEBUG_PRINTF("  Intens1: %5.2f",intens1);

  // Second Pixel
  intens1 = intens*fractionPixel;
  color   = pixels.Color(red*intens1, green*intens1, blue*intens1);
  setPixelLimited(pixel+1, color);
  DEBUG_PRINTF("  Intens2: %5.2f",intens1);
}

int lastSec=0;
/**
 * Shows the time on the Neo Pixel Ring
 */
void showTime() {
  clearPixel();

  // -----------------------------
  timeval tv;
  gettimeofday(&tv, NULL);
  
  time_t tnow = tv.tv_sec;
  struct tm *ti;
  ti = localtime(&tnow);

  // Newline for Debugging
  if ( lastSec != ti->tm_sec){
    DEBUG_PRINTF("\n");
    lastSec = ti->tm_sec;
  }

  double fractionSec=tv.tv_usec/1000000.0;
  
  double hour   = ti->tm_hour;
  double min = ti->tm_min;
  double sec = ti->tm_sec + fractionSec;
  // DEBUG_PRINTF("  Usec: %5.2f ",fractionSec);

  // Add fractions to values
  min  += (sec/60);
  hour += (min/60);

  // Adapt intensity by time (hours)
  intens=1.0;
  if ( hour <7 || hour>22){
    intens=.2;
  }

  double pixelPos;

  // Hour
  if ( hour >= 12 ) hour -= 12;
  setFloatingPixel(hour / 12, color_hour_r, color_hour_g , color_hour_b);
  //  DEBUG_PRINTF("  Hour: %2.0f ", hour);

  // Minute
  setFloatingPixel(min/60, color_min_r, color_min_g , color_min_b);
  // DEBUG_PRINTF("  Min: %2.0f ", min);

  // Seconds
  setFloatingPixel(sec/60, color_sec_r, color_sec_g , color_sec_b);
  // DEBUG_PRINTF("  Sec: %2.2f ", sec);

  DEBUG_PRINTF("\n");

  // Send pixels to display
  pixels.show();
  
  delay(10);
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
  //Serial.print( time);

  // SHow time on Neopixel Ring
  showTime();

  // Wait a little bit, so we do not flood the console
//  delay(1000.0 * 60.0/NUM_PIXELS/5.0);
  delay(10);

}
