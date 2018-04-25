/*
  Greina 3D terrain model interactive exhibition
  Museo Lottigna TI Switzerlan
  
  LCV SUPSI 2018
  
  Marco Lurati
*/

#define outputA 6
#define outputB 7

int aState;
int aLastState; 

boolean next, prev, old_next, old_prev;

void setup() {
  Serial.begin(9600);

  pinMode (outputA,INPUT);
  pinMode (outputB,INPUT);

  // Reads the initial state of the outputA
   aLastState = digitalRead(outputA);   
}

void loop() {

  aState = digitalRead(outputA); // Reads the "current" state of the outputA
  // If the previous and the current state of the outputA are different, that means a Pulse has occured
  if (aState != aLastState){     
  // If the outputB state is different to the outputA state, that means the encoder is rotating clockwise
    if (digitalRead(outputB) != aState) { 
      Serial.println(1);
      Serial.println(0);
    } else {
      Serial.println(2);
      Serial.println(0);
    }
  } 
  aLastState = aState; // Updates the previous state of the outputA with the current state
  
}
