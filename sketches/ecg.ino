// Part II: ECG aka EKG detection
int long prev = 0;
unsigned long counter = 0;
int ts = 1;
unsigned long countere1 = 0;
unsigned long countere2 = 0;
int ecgPin = A0;
int ecgInt = 0;
int n = 0;
int j = 0;
int ecgArray[400];
int ecgUpper = 600;
int ecgLower = 200;
int ecgGate = 0;
float ecgBPM = 0;

void setup() {
  pinMode(10,INPUT);
  pinMode(11,OUTPUT);
  Serial.begin(9600);
}

void loop() {
	if((digitalRead(10) == 1)||(digitalRead(11) == 1)) {
		Serial.println('!');
	}
	else {
		counter = millis();
		if (counter - prev > ts) {
		prev = counter;  
		ecgInt = analogRead(ecgPin);
		ecgArray[j] = ecgInt; 
		Serial.println(ecgInt);
		}
		if (ecgArray[j] > ecgUpper) {
			if (ecgArray[j-2] <= ecgArray[j-1] && ecgArray[j] < ecgArray[j-1]) {
				j = 0;
				if (ecgGate == 1) {
					countere2 = millis();
					float ecgT = (countere2 - countere1);
					if (60/(ecgT/1000) < 150 && ecgT > 100) {
						ecgBPM = 60/(ecgT/1000); 
					}
					Serial.print("******BPM (ECG)******* ");
					Serial.println(ecgBPM); 
					ecgGate = 0; 
				}
				else if (ecgGate == 0)	{
					countere1 = millis();
					ecgGate = 1;
				}
			}
		}
		if (ecgArray[j] < ecgLower) {
			if (ecgArray[j-2] >= ecgArray[j-1] && ecgArray[j] > ecgArray[j-1]) {
				j = 0;
				if (ecgGate == 1) {
					countere2 = millis();
					float ecgT = (countere2 - countere1);
					
					if (60/(ecgT/1000) < 150 && ecgT > 100) {
						ecgBPM = 60/(ecgT/1000); 
					}
					Serial.print("******BPM (ECG)******* ");
					Serial.println(ecgBPM);
					ecgGate = 0; 
				}
				else if (ecgGate == 0) {
					countere1 = millis();
					ecgGate = 1;
				}
			}
		} 
	}
	j = j + 1;
}

