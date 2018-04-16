/*
 * Museo Lottigna Ticino
 * Exhibition "Greina 2018"
 * 
 * SUPSI LCV
 * Marco Lurati
 * 
 * Lantern station and lights switching
 * 
 * Arduino UNO with Neopixel 7 round RGB
 * 
 */

// Libraries
#include <Adafruit_NeoPixel.h>

// pin DIN for the 64 Neopixel RGB Led
const int lamp_pin = 6;

// Neopixel matrix
Adafruit_NeoPixel lantern = Adafruit_NeoPixel(7, lamp_pin, NEO_RGBW);


// pin for relays (main lamps)
const int pinL1 = 2;
const int pinL2 = 3;

// main lamp status
boolean lamps = false;  // false = right, Tuor, true = left, Lavizzari

// message coming from processing
int message;

// timing
long old_millis;

// lantern animation
float brightness = 1;

void setup() {

  Serial.begin(9600);

  lantern.begin();

  for(int i=0; i<7; i++) {
    lantern.setPixelColor(i, lantern.Color(0, 0, 0));
  }

  lantern.show();

  pinMode(pinL1, OUTPUT);
  pinMode(pinL2, OUTPUT);
  pinMode(13, OUTPUT);

  digitalWrite(pinL1, LOW);
  digitalWrite(pinL2, LOW);

}

void loop() {

  if(Serial.available() > 0) {
    message = Serial.read();
    
    if(message == 1) lamps = true;    // Lavizzari, Left
    else if (message == 0) lamps = false;   // Tuor, Right
  
  }


  /*
  if(millis() > old_millis + 10000) {
    
    lamps = !lamps;
    old_millis = millis();

  }
  */

  digitalWrite(pinL1, lamps);
  digitalWrite(pinL2, !lamps);

  lampUpdate();


  digitalWrite(13, !lamps);
  
}

// lantern flickering
void lampUpdate() {

  if(!lamps) {    // switch on with right Tuor

    brightness = random(5, 10);
    
    // GRB
    for(int i=0; i<7; i++) {
      lantern.setPixelColor(i, lantern.Color((brightness/10 * random(5, 40)), (brightness/10 * random(200, 255)), 0));
    }

    delay(random(40, 80));
  } else {
    for(int i=0; i<7; i++) {
      lantern.setPixelColor(i, lantern.Color(0, 0, 0));
    }
  }

  lantern.show(); 

}



