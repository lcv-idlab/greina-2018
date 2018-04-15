/*
  Greina installation - Sala 5 audio installations
  Museo Lottigna TI Switzerlan
  
  LCV SUPSI 2018
  
  Marco Lurati
*/

import processing.serial.*;

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;


Serial Port;  // create a object for the serial class

Minim minim;

AudioPlayer[] files;

int cur;  // current file to play (array index)

void setup() {
  
  size(800, 600, P2D);
  
  // start the communication with Arduino
  String portName = Serial.list()[0];
  Port = new Serial(this, portName, 9600);  
  
  for(int i=0; i<Serial.list().length; i++) {
    println(Serial.list()[i]);
  }
 
  minim = new Minim(this);
  
  files = new AudioPlayer[2];
  files[0] = minim.loadFile("1.mp3", 1024);
  files[1] = minim.loadFile("2.mp3", 1024);
  
  background(0);
  
  while(!(Port.available() > 0)) {
    println("Arduino not detected jet...");
  }
  
  files[0].play();
  

}

void draw() {
  
  // Arduino communication
  if( Port.available() > 0) {
    if(!files[cur].isPlaying()) {
      files[cur].pause();
      files[cur].rewind();
      cur = 1 - cur;
      files[cur].play();
      println(cur);
    }
    Port.write(cur);
  }
}
