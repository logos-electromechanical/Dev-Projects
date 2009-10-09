/*
    This uses the BasicUse example and cycles through the rows.

    Pierce Nichols 2009-07-29 */

#include "Tlc5940.h"

#define ROWPIN0    12
#define ROWPIN1    7
#define ROWPIN2    6  
#define SWITCHPIN  19
#define BRIGHTPIN  14
#define BRIGHTAD   0
#define MAXLED     273
#define INITLED    136
#define NUMROWS    4

void setup()
{
  /* Call Tlc.init() to setup the tlc.
     You can optionally pass an initial PWM value (0 - 4095) for all channels.*/
  Tlc.init();
  
  /* initialize the outputs for the row switch */
  
  pinMode(ROWPIN0, OUTPUT);
  pinMode(ROWPIN1, OUTPUT);
  pinMode(ROWPIN2, OUTPUT);
  
  /* initialize inputs for switch & brightness */
  
  pinMode(SWITCHPIN, INPUT);
  digitalWrite(SWITCHPIN, HIGH);
  pinMode(BRIGHTPIN, INPUT);
  
  /* set TLC5940 initial output */

  Tlc.setAll(((analogRead(BRIGHTAD)>>6)*MAXLED));
  Tlc.update();
  
}

void loop()
{
  int chan = 0, row = 1;
  for (row = 1; row <= NUMROWS; row++)  { 
    if (digitalRead(SWITCHPIN)) Tlc.clear();
    else Tlc.setAll(((analogRead(BRIGHTAD)>>6)*MAXLED));
    digitalWrite(ROWPIN0, bitRead(row, 0));
    digitalWrite(ROWPIN1, bitRead(row, 1));
    digitalWrite(ROWPIN2, bitRead(row, 2));
    Tlc.update();
    delay(10);  
  }

}

