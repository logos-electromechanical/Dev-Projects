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
#define SEEDPIN    16
#define SEEDAD     2
#define RANDMAX    6
#define RANDMIN    -5

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
  pinMode(SEEDPIN, INPUT);
  digitalWrite(SWITCHPIN, HIGH);
  pinMode(BRIGHTPIN, INPUT);
  
  /* set TLC5940 initial output */

  Tlc.setAll(((analogRead(BRIGHTAD)>>6)*INITLED));
  Tlc.update();
  
  /* seed the random number generator */
  
  randomSeed(analogRead(SEEDAD));
  
}

void loop()
{
  int chan = 0, row = 1, val = 0;
  static int last_mult, mult = 0;
  
  for (row = 1; row <= NUMROWS; row++)  { 
    last_mult = mult;
    mult = (analogRead(BRIGHTAD)>>6);
    if (digitalRead(SWITCHPIN)) mult = 0;
    for (chan = 0; chan < (NUM_TLCS * 16); chan++) {
      val = Tlc.get(chan)/last_mult;
      val += random(RANDMIN, RANDMAX);
      if (val > MAXLED) val = MAXLED;
      if (val < 0) val = 0;
      val *= mult;
      Tlc.set(chan, val);
    }
    digitalWrite(ROWPIN0, bitRead(row, 0));
    digitalWrite(ROWPIN1, bitRead(row, 1));
    digitalWrite(ROWPIN2, bitRead(row, 2));
    Tlc.update();
    
    delay(10);  
  }

}

