import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Greina_model extends PApplet {

/*
  Greina 3D terrain model interactive exhibition
  Museo Lottigna TI Switzerlan
  
  LCV SUPSI 2018
  
  Marco Lurati
*/



Serial Port;  // create a object for the serial class
String val;  // value sent by the Arduino

String[] imagesNames = {"01.png", "02.png", "03.png", "04.png", "05.png", "06.png", "07.png", "08.png", "09.png", "10.png", "11.png", "12.png", "13.png", "14.png"};
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


public void setup() {
  //fullScreen();
  noCursor();
  frameRate(fps);
  
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


public void draw() {
  
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

public void resetDemo() {
  demo = false;
  old_demo_millis = millis();
  println("Demo mode OFF");
}

public void checkDemo() {
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

public void posCheck() {
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

public void changeImage() {
  
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
/* Configuration page */

// seconds after witch the demo mode starts
int demo_delay = 20;

// intervall in seconds during the demo mode
int demo_interval = 10;   

// images fading time in seconds
float fading_time = 1;
  public void settings() {  size(1920, 1080, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Greina_model" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
