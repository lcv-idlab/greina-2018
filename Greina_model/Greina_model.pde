/*
  Greina 3D terrain model interactive exhibition
  Museo Lottigna TI Switzerlan
  
  LCV SUPSI 2018
  
  Marco Lurati
*/

import processing.serial.*;

Serial Port;  // create a object for the serial class
String val;  // value sent by the Arduino

String[] imagesNames = {"1.png", "2.png", "3.png", "4.png", "5.png", "6.png"};
int imagesCount = imagesNames.length;
PImage[] images = new PImage[imagesCount];

int pos, old_pos, curr_pos, old_saved_pos;  // current image displayed and old image displayed

// DEMO
boolean demo = true;  // automatically scroll content if no interactions from visitors
long old_demo_millis;  // old millis used to detect if to enter in demo mode
long old_demo_interval; // old millis used to scroll the images

// FADING
long old_fade;  // old millis used to fade images when changing
float alpha = 0;  // alpha channgel of the fill rect used for fading
boolean fade_out = false;  // used for avoiding changing pos while fading out (better visual feedback)

int fps = 60;  // sketch fps, used to calculate the alpha fading increments


void setup() {
  //fullScreen();
  noCursor();
  frameRate(fps);
  size(1920, 1080, P2D);
  background(0);
  noStroke();
  noFill();
  
  // start the communication with Arduino
  String portName = Serial.list()[0];
  Port = new Serial(this, portName, 9600);
  
  // load all the images
  for(int i=0; i< imagesCount; i++) {
    images[i] = loadImage(imagesNames[i]);
  }
  
  image(images[pos], 0, 0);
}


void draw() {
  
  // Arduino communication
  if( Port.available() > 0) {
    val = trim(Port.readStringUntil('\n'));
  }
  
  if(val != null && !fade_out) {
    
    if(val.equals("2")) {
      println("next");
      old_pos = pos;
      pos++;
      resetDemo();
    } else if(val.equals("1")) {
      println("previous");
      old_pos = pos;
      pos--;
      resetDemo();
    }
  }
    
  checkDemo();
  
  posCheck();
  
  changeImage();
  
}

void resetDemo() {
  demo = false;
  old_demo_millis = millis();
  println("Demo mode OFF");
}

void checkDemo() {
  if(millis() > (old_demo_millis + demo_delay*1000)) {
    demo = true;
  }
  
  if(demo) {
    if(millis() > (old_demo_interval + demo_interval*1000)) {
      pos++;
      old_demo_interval = millis();
      println("Demo mode ON");
    }
  }
}

void posCheck() {
  if(pos < 0) {
    pos = imagesCount-1;
  } else if(pos >= imagesCount) {
    pos = 0;
  }
  
  if(pos != old_pos) {
    old_fade = millis();
    old_saved_pos = old_pos;
  }
 
}

void changeImage() {
  
  if(millis() < old_fade + fading_time*1000/2) {  // usign only half of the time to fade out
    alpha += (255/(fps * fading_time/2));
    curr_pos = old_saved_pos;
    fade_out = true;
  } else if(millis() > old_fade + fading_time*1000/2) {
    alpha -= (255/(fps * fading_time/2));
    curr_pos = pos;
    fade_out = false;
  }
  
  // limit the alpha values
  if(alpha > 255) alpha = 255;
  else if( alpha < 0) alpha = 0;
  
  image(images[curr_pos], 0, 0);
  
  fill(0, alpha);
  rect(0, 0, width, height);
    
  old_pos = pos;
}
