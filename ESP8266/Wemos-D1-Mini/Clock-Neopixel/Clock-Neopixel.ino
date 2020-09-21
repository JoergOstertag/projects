/****************************************************************************************************************************

  Get the time with ntp and display the time on a neopixel Ring
  
  You can specify the number of pixels in the LED Ring with NUM_PIXELS
  
  The variables handXxx... specifies the base RGB value and width of the pointers (hour,minute,second)
  
  Wifi Setup is derived from Example AutoConnect.ino using library https://github.com/khoih-prog/ESP_WiFiManager

  To configure Wifi on the device:
   - connect to an AP called ESP_XXXXXXX
   - enter http://192.168.4.1/ into browser and configure the AP and pwd

 *****************************************************************************************************************************/

// Uncomment for continuous Debug Output
#define DEBUG
 
// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin

// Define Number of pixels in Neo Pixel Ring
#define NUM_PIXELS    24
//#define NUM_PIXELS    50
// #define NUM_PIXELS    27

// Pixel Number of the first pixel (Showing Midnight)
// 0 means the first pixel is at the top of the ring
#define PIXEL_OFFSET  0

// to get inverse direction of the pixels set to true
// to get normal direction of the pixels set to false
#define PIXEL_DIRECTION_INVERSE false

// Hardware Pin of Neopixel String
#define NEOPIXEL_PIN  D4
//#define NEOPIXEL_PIN  D2

// Base definition for the pointers (Hour,Minute,Second)
struct handColorRGB {
  int red;
  int green;
  int blue;
  int width; // Width in Pixel
};


// maximum wanted intensity
int iMax=50;

// RGB color for the different hand
//                             red, geen,  blue, width
handColorRGB handHour    = {    0,    0, iMax , 3 };  // Hour   ==> Blue
handColorRGB handMinute  = {    0, iMax,    0 , 2 };  // Minute ==> Green
handColorRGB handSecond  = { iMax, iMax,    0 , 1 };  // Second ==> Yellow
handColorRGB markQuater  = {    2,    2,    2 , 1 };

// The relative intensity of all LEDs
double intens = 1.0;

// This is the intensity factor to dim the LEDs at night
#define NIGHT_DIM_FACTOR 0.2
//#define NIGHT_DIM_FACTOR 0.99

 
// -----------------------------------------------------------
// Lib for Neopixel Ring
#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels(NUM_PIXELS, NEOPIXEL_PIN, NEO_GRB | NEO_KHZ800);

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
    DEBUG_PRINTF(" Set Pixel %2d #%04X ",pixel,color);
    
    pixels.setPixelColor(pixel, color);
}

 uint32_t toColor(double intens , handColorRGB handColor ){
    return pixels.Color(handColor.red * intens, handColor.green * intens, handColor.blue * intens);
}

/**
 * Set pixel at pixelPos to specified RGB-color
 * The number of the pixelPos is a double which is normalized between 0.0 and 1.0
 * where 0 is the first pixel. 1.0 is overflow and also the first pixel. 
 * where 1.0 -(1/NUM_PIXELS) is equivalent to the last pixel.
 * We also find out if the pixelposition is between two pixels. 
 * If we have a position inbetween two LEDs, we dim both pixels accordingly 
 * to show where inbetween the two pixels the real position is.
 * In addition we take handColor.width to show multiple pixels with this width.
 * 
 */
void setFloatingPixel(double pixelPos, handColorRGB handColor ){

  double pixel = pixelPos * NUM_PIXELS;
  if ( PIXEL_DIRECTION_INVERSE ) {
    pixel = (1.0-pixelPos) * NUM_PIXELS;
  }

  double fractionPixel=pixel-floor(pixel);
  DEBUG_PRINTF(" Pixel(Pos:%4.2f #:%3.0f)", pixelPos,pixel);

  int pixelMin= pixel- (handColor.width/2);
  int pixelMax= pixelMin + handColor.width;

  // First Pixel
  double intens1 = intens*(1.0-fractionPixel);
  uint32_t color = toColor(intens1,handColor);
  DEBUG_PRINTF(" I1:%4.2f",intens1);
  setPixelLimited(pixelMin, color);

  for ( int i = pixelMin+1; i < pixelMax; i++ ){
    uint32_t color = toColor(intens,handColor);
    setPixelLimited(i, color);
  }


  // Second Pixel
  intens1 = intens*fractionPixel;
  color   = toColor(intens1,handColor);
  DEBUG_PRINTF(" I2:%4.2f",intens1);
  setPixelLimited(pixelMax, color);
}

int lastSec=0;
/**
 * Shows the time on the Neo Pixel Ring
 */
void showTime() {
  clearPixel();

  DEBUG_PRINTF("\nMarker 1 ");
  setFloatingPixel(0.0  , markQuater);
  DEBUG_PRINTF("\nMarker 2 ");
  setFloatingPixel(1.0/4, markQuater);
  DEBUG_PRINTF("\nMarker 3 ");
  setFloatingPixel(2.0/4, markQuater);
  DEBUG_PRINTF("\nMarker 4 ");
  setFloatingPixel(3.0/4, markQuater);

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
    intens=NIGHT_DIM_FACTOR;
  }

  double pixelPos;

  // Hour
  if ( hour >= 12 ) hour -= 12;
  DEBUG_PRINTF("\n  Hour: %2.0f    ", hour);
  setFloatingPixel(hour / 12, handHour);

  // Minute
  DEBUG_PRINTF("\n  Min:  %2.0f    ", min);
  setFloatingPixel(min/60, handMinute);

  // Seconds
  DEBUG_PRINTF("\n  Sec:  %5.2f ", sec);
  setFloatingPixel(sec/60, handSecond);

  DEBUG_PRINTF("\n");
  DEBUG_PRINTF("\n");

  // Send pixels to display
  pixels.show();

  delay(10);
  #ifdef DEBUG
    delay(1000);
  #endif
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
