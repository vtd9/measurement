// Part I: Pulse Photodetection
int long prev = 0;
unsigned long counter = 0;
unsigned long counterp1 = 0;
unsigned long counterp2 = 0;
int photoPin = A5;
int blinkPin = 13;
int ts = 10;
int voltInt = 0;
int n = 0;
int i = 0;
int pulArray[400];
int threshold = 500;
int pulGate = 0;
float pulseBPM;

void setup() {
  pinMode(blinkPin,OUTPUT);
  Serial.begin(9600);
}

void loop() {
counter = millis();
if (counter - prev > ts){
  prev = counter;  
  voltInt = analogRead(photoPin);
  pulArray[i] = voltInt; 
  //Serial.print(i);
  //Serial.print("\t");
  Serial.println(voltInt);
  
  if (pulArray[i] > threshold) {
    if (pulArray[i-2] <= pulArray[i-1] && pulArray[i] < pulArray[i-1]){
      if (pulArray[i-50] < pulArray[i]){ // Make sure absolute max
        if (pulGate == 1){
          counterp2 = millis();
          float pulseT = (counterp2 - counterp1);
          if (60/(pulseT/1000) < 200 && pulseT > 100){
            pulseBPM = 60/(pulseT/1000); 
            }
          //Serial.print("BPM: ");
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
i = i + 1;

// Blinking LED: comparison w/ carotid or radial pulse
  if(voltInt > (threshold)){
    digitalWrite(blinkPin,HIGH);
    }
  else
    digitalWrite(blinkPin,LOW);

}
}
