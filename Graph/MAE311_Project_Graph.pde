import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;
import processing.serial.*;
PrintWriter output;

// Input variables:
int port = 0;             //Arduino's COM Port
int baud = 9600;
float ymax = 1000; 
float ymin = 0;
float yspace = 100;
String myString = null;
Serial myPort;  
int lf = 10;              // ASCII Linefeed
float num;   
float graphnum = 1;
long previousMillis = 0;
long interval = 250;
long currentMillis = 0;
RollingLine2DTrace r;
Graph2D g;

void setup(){
        size(600,400);
          myPort = new Serial(this, Serial.list()[port], baud);
          myPort.clear();
          output = createWriter("pulserec.csv");
        class eq implements ILine2DEquation{
  public double computePoint(double x,int pos) {
    return graphnum;
      }    
        }
  r  = new RollingLine2DTrace(new eq() ,100,0.1f);
  r.setTraceColour(255, 0, 0);
  g = new Graph2D(this, 400, 300, false);
  g.setYAxisMax(300);
  g.addTrace(r);
  g.position.y = 50;
  g.position.x = 100;
        g.setYAxisMax(ymax);
        g.setYAxisMin(ymin);
        g.setXAxisMin(0);
  g.setYAxisTickSpacing(yspace);
        g.setXAxisTickSpacing(1);
  g.setXAxisMax(5f);
        g.setXAxisLabel("Time (s)");
        g.setYAxisLabel("Y");
}

void draw(){
currentMillis = millis();           //record the current time
background(255,250,250);
g.draw();

//Reading Serial Data  
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
      if (myString != null) {
          num=float(myString);  
          num=float(floor(num*1000))/1000; 
          println(currentMillis+ "\t" +num+ "");
          output.println(currentMillis+ "," +num);
      } 
      }
myPort.clear();

if(currentMillis - previousMillis > interval){
  previousMillis = currentMillis;
      graphnum = num;
 }
} 

// Stop program with a keypress
void keyPressed() { 
  output.flush(); 
  output.close(); 
  exit(); 
}