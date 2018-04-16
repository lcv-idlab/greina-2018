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
  
  printArray(Serial.list());
 
  minim = new Minim(this);
  
  files = new AudioPlayer[2];
  files[0] = minim.loadFile("Tuor.wav", 1024);
  files[1] = minim.loadFile("Lavizzari.wav", 1024);
  //files[0] = minim.loadFile("1.mp3", 1024);
  //files[1] = minim.loadFile("2.mp3", 1024);
  
  background(0);
  
  delay(3000);
  
  files[0].play();
  
  Port.write(cur);

}

void draw() {
  
  // Arduino communication anc changing track
    if(!files[cur].isPlaying()) {
      files[cur].pause();
      files[cur].rewind();
      cur = 1 - cur;
      files[cur].play();
      println(cur);
      Port.write(cur);
    }
}
