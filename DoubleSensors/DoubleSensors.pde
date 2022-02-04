

 // Graphing sketch


// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects values in the
// range 0 to 1023, followed by a newline, or newline and carriage return
// Created 19 Jan 2016
// Updated 20 Jan 2016
// by Sarath Babu
// This example code is in the public domain.

import processing.serial.*;
PrintWriter output;
Serial myPort;        // The serial port
int x1 = 0;    // horizontal position of the first graph
int x2 = 400;   // horizontal position of the second graph
float inByte1 = 0;
float inByte2 = 0;

void setup () {
  size(800, 400);
    myPort = new Serial(this, Serial.list()[0], 9600);
    output = createWriter("pulsedoubl.csv");
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(0);
  //Create the first rectangle
  fill(100);
  rect(0,0,400,400);
  //Create the second rectangle
  fill(100);
  rect(400,0,400,400);
}
void draw () {
  // draw the line of the first sensor:
  stroke(0,200,0);
  line(x1, 400, x1, 400 - inByte1);

  // at the half length of the screen, go back to the beginning:
  if (x1 >= 400) {
    x1= 0;
    fill(100);
    rect(0,0,400,400);
  }
    // increment the horizontal position:
    x1++;
    //draw the line of the second sensor
    stroke(0,0,200);
  line(x2, 400, x2, 400 - inByte2);
  // at the edge of the screen, go back to the beginning:
  if (x2 >= 800) {
    x2= 400;
    fill(100);
    rect(400,0,400,400);
  }
    // increment the horizontal position:
    x2++;
}


void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    //Split the string value dot as delimiter
    float[] nums=float(split(inString,"."));
    //nums[0]=first sensor value
  println("First sensor value="+nums[0]);
  //nums[1]=second sensor value
  println("Second Sensor value="+nums[1]);
    // convert to an int and map to the screen height:
    inByte1 = float(inString);
    output.println(inByte1);
    //map the first sensor value
    inByte1 = map(nums[0], 400, 700, 0, 400);
    //map the second sensor value
    inByte2=map(nums[1],300,700,0,400);
  }
}
// Stop program with a keypress
void keyPressed() { 
  output.flush(); 
  output.close(); 
  exit(); 
}