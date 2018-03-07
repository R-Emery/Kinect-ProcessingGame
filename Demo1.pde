/*************************************************************/
/* Authors: Ricky Emery, Sarah Deters, Allison Landino       */
/* Created: Wednesday March 7th 2018                         */
/*************************************************************/

import org.openkinect.processing.*;

Kinect2 kinect2;

float minThresh = 0;   //Global var - Minimum Depth Threshold
float maxThresh = 830; //Global var - Maximum Depth Threshold
PImage img; //Global var - PImage
PShape svg; //Global var - PShape for loading in svg files

void setup() {
  size(1440, 900);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  svg = loadShape("volcano-02b.svg");
}


void draw() {
  background(0);

  img.loadPixels();

  PImage dImg = kinect2.getDepthImage();
  //image(dImg, 0, 0); // DISPLAY IMAGE

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();
  
  // RECORD HEIGHT
  /*int record = kinect2.depthHeight;
  int rx = 0;
  int ry = 0;*/
  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;

  for (int x = 0; x < kinect2.depthWidth; x++) {
    for (int y = 0; y < kinect2.depthHeight; y++) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh) {
        img.pixels[offset] = color(255, 0, 150);
        sumX += x;
        sumY += y;
        totalPixels++;
        /*if (y < record) {
          record = y;
          rx = x;
          ry = y;
        }*/
        
        
      } else {
        img.pixels[offset] = color(0);
        //img.pixels[offset] = dImg.pixels[offset];
      }
    }
  }
  img.updatePixels();
  //image(img,0,0);
  
  float avgX = sumX / totalPixels;
  float avgY = sumY / totalPixels;
  
  shape(svg,0,0,width/2,height);
  
  fill(0,255,0);
  rect(width/2,0,width/2,height);

  //TEST CASES FOR TRACKING ELLIPSE LOCATION
  //fill(255);
  //ellipse(avgX, avgY, 32, 32);
  //println("X = " + avgX);
  //println("Y = " + avgY);
  
  if (avgX < 288) {
    println("You Lose!");
  } else {
    println("You Win!");
  }
}

// Adjust the threshold with key presses
void keyPressed() {  
  if (key == CODED) {
    if (keyCode == UP) {
      maxThresh +=15;
      //tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      maxThresh -=15;
      //tracker.setThreshold(t);
    } else if (keyCode == LEFT) {
      maxThresh -=5;
    } else if (keyCode == RIGHT) {
      maxThresh +=5;
    }
  }
}
