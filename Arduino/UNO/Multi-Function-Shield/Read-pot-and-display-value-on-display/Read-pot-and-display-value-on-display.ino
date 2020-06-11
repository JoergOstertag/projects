
/* Define shift register pins used for seven segment display */
#define LATCH_DIO 4
#define CLK_DIO 7
#define DATA_DIO 8

#define Pot1 0

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0X80, 0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1, 0xF2, 0xF4, 0xF8};

void setup ()
{
  Serial.begin(115200);
  /* Set DIO pins to outputs */
  pinMode(LATCH_DIO, OUTPUT);
  pinMode(CLK_DIO, OUTPUT);
  pinMode(DATA_DIO, OUTPUT);

}

/* Main program */
void loop()
{
  int PotValue;
  PotValue = analogRead(Pot1);
  Serial.print("Potentiometer: ");
  Serial.println(PotValue);

  /* Update the display with the current counter value */
  WriteNumber(PotValue );

}

/* Write a decimal number between 0 and 9999 to the display */
void WriteNumber(int Number)
{
  WriteNumberToDigit(0 , Number / 1000);
  WriteNumberToDigit(1 , (Number / 100) % 10);
  WriteNumberToDigit(2 , (Number / 10) % 10);
  WriteNumberToDigit(3 , Number % 10);
}

/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToDigit(byte digit, byte Value)
{
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[digit] );
  digitalWrite(LATCH_DIO, HIGH);
}

