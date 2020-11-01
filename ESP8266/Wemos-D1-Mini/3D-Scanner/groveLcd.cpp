#include <Wire.h>
#include <rgb_lcd.h> // https://github.com/Seeed-Studio/Grove_LCD_RGB_Backlight

#include "groveLcd.h"

#include "webServer.h"
#include "config.h"

#include "resultStorageHandler.h"

#include "positioner.h"
#include "timeHelper.h"
#include "getDistance.h"

rgb_lcd lcd;

void groveLcdSetup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);

  lcd.setRGB(0, 200, 0);

  // Print a message to the LCD.
  lcd.print("Init done");
}

void groveLcdLoop(PolarCoordinate position) {

  lcd.setCursor(0, 1);

  lcd.print("Az: ");    lcd.print(position.az );
  lcd.print("El: ");    lcd.print(position.el );

  lcd.print("Init done");

}
