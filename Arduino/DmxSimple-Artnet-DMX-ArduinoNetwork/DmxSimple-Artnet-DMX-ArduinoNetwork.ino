/*
 * Proof of concept for an ARTNet-->DMX converter 
 * Based on an Arduino Mega, a Network shield and an DMX Shield
 * 
 This sketch receives UDP message strings containing ARTNet messages
 
 There are no checks about consistency yet, since it only is a proof of concept.
 The Code Parts are taken from the included Libraries
  Hardware:
    - https://de.aliexpress.com/item/32841371527.html
      DMX Schild/Expansion Kompatibel für Arduino 1,0 für DMX-Master gerät/grafik in DMX512 netzwerke
    - https://de.aliexpress.com/item/32549379444.html
      UNO Schild Ethernet Schild W5100 R3 UNO Mega 2560 1280 328 UNR R3 nur W5100 Entwicklung board FÜR Arduino
    - https://de.aliexpress.com/item/32665500106.html?spm=a2g0s.12269583.0.0.713d4349nk6Hk0
      Arduino Mega 2560 R3 Mega2560 REV3 (ATmega2560-16AU CH340G) Board
    
  Testing was done with the following Programms as ARTNet Sources:
    - QLC+ https://qlcplus.org/
    - OpenHAB DMX Plugin https://www.openhab.org/
    - Modified DMX Sender from https://git.cle.ar.it/younix/dmx
  Copyright (c) 2019 Jan Klemkow and Jörg Ostertag
  
  MIT License
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/


#include <Ethernet.h>
#include <EthernetUdp.h>
#include <DmxSimple.h>
#include <Arduino.h>

// Maximum Bytes Shown in Debug Message
#define MAX_SHOW 80

// ARTNet Structure
struct dmxnet {
  char magic[8]; // ARTNET Magic Byte TODO: Check
  uint16_t opc;
  uint16_t ver;  // ArtNet Version Number TODO: Check
  uint8_t  seq;  // Sqence Number TODO: Check
  uint8_t  phy;
  uint16_t uni;  // Universe Number TODO: check endiannes, only react to single Universe
  uint8_t lenH;  // High Byte of the length (content)
  uint8_t lenL;  // Low Byte of the length (content)
  uint8_t content[512];
} __attribute__((packed, aligned(1)));


// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};

unsigned int localPort = 6454;      // local port to listen on

// buffers for receiving and sending data
//char packetBuffer[UDP_TX_PACKET_MAX_SIZE];  // buffer to hold incoming packet,
#define UDP_PACKET_MAX_SIZE 4096

char packetBuffer[UDP_PACKET_MAX_SIZE];  // buffer to hold incoming packet,
struct dmxnet artNetBuffer;


// An EthernetUDP instance to let us send and receive packets over UDP
EthernetUDP Udp;

int DEBUG=1;

int PIN_DS = 2;
int PIN_TX = 4;
int MAX_CHANNEL = 512;


void DmxInit(){
  
  pinMode(PIN_DS, OUTPUT);
  digitalWrite(PIN_DS, HIGH);

  /* The most common pin for DMX output is pin 3, which DmxSimple
  ** uses by default. If you need to change that, do it here. */
  DmxSimple.usePin(PIN_TX);

  /* DMX devices typically need to receive a complete set of channels
  ** even if you only need to adjust the first channel. You can
  ** easily change the number of channels sent here. If you don't
  ** do this, DmxSimple will set the maximum channel number to the
  ** highest channel you DmxSimple.write() to. */
  DmxSimple.maxChannel(MAX_CHANNEL);
}


void setup() {
  // You can use Ethernet.init(pin) to configure the CS pin
  //Ethernet.init(10);  // Most Arduino shields
  //Ethernet.init(5);   // MKR ETH shield
  //Ethernet.init(0);   // Teensy 2.0
  //Ethernet.init(20);  // Teensy++ 2.0
  //Ethernet.init(15);  // ESP8266 with Adafruit Featherwing Ethernet
  //Ethernet.init(33);  // ESP32 with Adafruit Featherwing Ethernet

  // start the Ethernet
  Ethernet.begin(mac);

  // Open serial communications and wait for port to open:
  Serial.begin(115200);
  if (!Serial) {
    delay(1000);
  }
  
  //while (!Serial) {
  //    ; // wait for serial port to connect. Needed for native USB port only
  //}

  // Check for Ethernet hardware present
  if (Ethernet.hardwareStatus() == EthernetNoHardware) {
    Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
    while (true) {
      delay(1); // do nothing, no point running without Ethernet hardware
    }
  }
  if (Ethernet.linkStatus() == LinkOFF) {
    Serial.println("Ethernet cable is not connected.");
  }

  // start UDP
  Udp.begin(localPort);

  if (Serial) {
    Serial.print("Listening on ");
    Serial.print(Ethernet.localIP());
    Serial.print(":");
    Serial.print(localPort);
    Serial.println();
  }
  
  DmxInit();

}

void SerialPrintIPAddress(IPAddress remote){
  for (int i=0; i < 4; i++) {
    Serial.print(remote[i], DEC);
    if (i < 3) {
      Serial.print(".");
    }
  }
  Serial.print(":");
  Serial.print(Udp.remotePort());
}

void loop() {
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();
  if (packetSize) {

    // read the packet into packetBufffer
    Udp.read(packetBuffer, UDP_PACKET_MAX_SIZE);
    
   // Serial.println(packetBuffer);
    memcpy(&artNetBuffer,&packetBuffer,packetSize);
    
    // Change from Network Order to littleEndian Order
    int len = (((int)artNetBuffer.lenH)<<8)+artNetBuffer.lenL;

    for (int i=0; i < len; i++) {
        DmxSimple.write(i+1,   artNetBuffer.content[i]);
    }
    //DmxSimple.maxChannel(len);

    if (Serial) {
      IPAddress remote = Udp.remoteIP();
      SerialPrintIPAddress(remote);
      
      Serial.print(" ");
      
      Serial.print(F("packet-size="));
      Serial.print(packetSize);
      Serial.print(" ");
    
      Serial.print("len(");
      Serial.print(len);
      Serial.print(") ");

      Serial.print("ART-Net Contents: ");
      for (int i=0; i < len && i < MAX_SHOW; i++) {
        Serial.print(" ");
        Serial.print(artNetBuffer.content[i], HEX);
      }
      Serial.println();
    }

  }
  delay(100);
}
