/*
  Greina 3D terrain model interactive exhibition
  Museo Lottigna TI Switzerlan
  
  LCV SUPSI 2018
  
  Marco Lurati
*/

const int pinNext = 2;
const int pinPrev = 3;

boolean next, prev, old_next, old_prev;

const int antibump = 100;

long old_millis_next, old_millis_prev;

void setup() {
  Serial.begin(9600);

  pinMode(pinNext, INPUT);
  pinMode(pinPrev, INPUT);

}

void loop() {

  next = digitalRead(pinNext);
  prev = digitalRead(pinPrev);

  if(next) {
    if(!old_next) {
      if(millis() > old_millis_next + antibump) {
        Serial.println(1);
        old_next = true;
        old_millis_next = millis();
        Serial.println(0);
      }
    }
  } else {
    old_next = false;
  }

  if(prev) {
    if(!old_prev) {
      if(millis() > old_millis_prev + antibump) {
        Serial.println(2);
        old_prev = true;
        old_millis_prev = millis();
        Serial.println(0);
      }
    }
  } else {
    old_prev = false;
  }
  
}
