// MAE 3xx Project
// Spring 2017
// Group 14

int long prev = 0;
unsigned long counter = 0;
int ts = 10;

// Pulse photodetection variables:
unsigned long counterp1 = 0;
unsigned long counterp2 = 0;
int photoPin = A5;
int blinkPin = 13;
int voltInt = 0;
int n = 0;
int i = 0;
int pulArray[200];
int threshold = 500;
int pulGate = 0;
float pulseBPM;

// ECG variables:
unsigned long countere1 = 0;
unsigned long countere2 = 0;
int ecgPin = A0;
int ecgInt = 0;
int j = 0;
int ecgArray[300];
int ecgUpper = 600;
int ecgLower = 250;
int ecgGate = 0;
float ecgBPM;

void setup() {
  pinMode(blinkPin,OUTPUT);
  Serial.begin(9600);
  pinMode(10,INPUT);
  pinMode(11,OUTPUT);
}

void loop() {
if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
    Serial.println('!');
  }
counter = millis();
if (counter - prev > ts){
  prev = counter;  
  
  voltInt = analogRead(photoPin);
  pulArray[i] = voltInt; 
  
  ecgInt = analogRead(ecgPin);
  ecgArray[j] = ecgInt; 
}
  Serial.print(voltInt);
  //Serial.print("."); // Use as period instead of \t for Processing graphing
  Serial.print("\t"); 
  Serial.println(ecgInt);

/////// Photodetection Analysis ///////  
if (pulArray[i] > threshold){
  if (pulArray[i-2] < pulArray[i-1] && pulArray[i] < pulArray[i-1]){
    if (pulArray[i-50] < pulArray[i]){ // Make sure absolute max
      if (pulGate == 1){
        counterp2 = millis();
        float pulseT = (counterp2 - counterp1);
        if (60/(pulseT/1000) < 200 && pulseT > 100){
          pulseBPM = 60/(pulseT/1000); 
          }
        //Serial.print("******BPM (Photo.)****** ");
        //Serial.println(pulseBPM);
        pulGate = 0; 
        i = 0;
      }
      else if (pulGate == 0){
        counterp1 = millis();
        pulGate = 1;
      }
    }
}
}
// Blinking LED: comparison w/ carotid or radial pulse: 
if(voltInt > (threshold)){
  digitalWrite(blinkPin,HIGH);
  }
else
  digitalWrite(blinkPin,LOW);

/////// ECG Analysis ///////
  if (ecgArray[j] > ecgUpper){
    if (ecgArray[j-2] <= ecgArray[j-1] && ecgArray[j] < ecgArray[j-1]){
        j = 0;
        if (ecgGate == 1){
          countere2 = millis();
          float ecgT = (countere2 - countere1);
          if (60/(ecgT/1000) < 150 && ecgT > 100){
            ecgBPM = 60/(ecgT/1000); 
            }
          //Serial.print("******BPM (ECG)******* ");
          //Serial.println(ecgBPM); 
          ecgGate = 0; 
        }
        else if (ecgGate == 0){
          countere1 = millis();
          ecgGate = 1;
        }
      }
  }
  if (ecgArray[j] < ecgLower){
      if (ecgArray[j-2] >= ecgArray[j-1] && ecgArray[j] > ecgArray[j-1]){
          j = 0;
          if (ecgGate == 1){
            countere2 = millis();
            float ecgT = (countere2 - countere1);
            if (60/(ecgT/1000) < 150 && ecgT > 100){
              ecgBPM = 60/(ecgT/1000); 
              }
            //Serial.print("******BPM (ECG)******* ");
            //Serial.println(ecgBPM);
            ecgGate = 0; 
          }
          else if (ecgGate == 0){
            countere1 = millis();
            ecgGate = 1;
          }
        }
      }
  i = i + 1;
  j = j + 1;  
}
