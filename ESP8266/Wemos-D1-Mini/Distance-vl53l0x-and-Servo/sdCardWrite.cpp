/*
  SD card read/write

  This example shows how to read and write data to and from an SD card file
  The circuit:
   SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13

  created   Nov 2010
  by David A. Mellis
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

*/
#include "sdCardWrite.h"

#include "timeHelper.h"
#include "resultStorageHandler.h"

#include <SPI.h>
#include "SdFat.h"
SdFat SD;

#define SD_CS_PIN SS
File myFile;


void readSdCardFile(String fileName) {
  // re-open the file for reading:
  myFile = SD.open(fileName);
  if (myFile) {
    Serial.println("test.txt:");

    // read from the file until there's nothing else in it:
    int lineCount = 0;
    while (myFile.available()) {
      Serial.write(myFile.read());
      lineCount++;
      ESP.wdtFeed();
      delay(1);
    }
    // close the file:
    myFile.close();
    Serial.printf("Seen %d Lines\n", lineCount);
  } else {
    // if the file didn't open, print an error:
    Serial.println("error opening test.txt");
  }
}

void sdCardWrite(ResultStorageHandler &resultStorageHandler) {

  Serial.print(F("\nInitializing SD card..."));

  if (!SD.begin(SD_CS_PIN)) {
    Serial.println("initialization failed!");
    return;
  }
  Serial.println("SD-Card initialization done.");


  String fileName = dateTimeString() + ".csv";
  Serial.print("Using File: "); Serial.println(fileName);

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  myFile = SD.open(fileName, FILE_WRITE);

  // if the file opened okay, write to it:
  if (myFile) {
    Serial.print("Writing to " + fileName + " ...");
    myFile.println("az,el,distance");

    String output;
    output.reserve(2000);

    for ( int i = 0; i < resultStorageHandler.maxIndex(); i++) {
      PolarCoordinate position = resultStorageHandler.getPosition(i);

      output = position.az;
      output += ";";
      output += position.el;
      output += ";";
      output += resultStorageHandler.getResult(i);
      myFile.println(output );

    }

    // close the file:
    myFile.close();
    Serial.println("done.");
  } else {
    // if the file didn't open, print an error:
    Serial.println("error opening test.txt");
  }

  readSdCardFile(fileName);
}
