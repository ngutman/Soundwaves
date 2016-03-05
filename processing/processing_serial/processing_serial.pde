import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int canvasHeight;

void setup() 
{
  size(1300, 500);
  canvasHeight = 500;
  background(0);
  initPort();
}

String myString;
int lf = 10;
float[] freqValues = new float[60];

void draw()
{
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString == null) {
      continue;
    }
    readFreqs();
    createBands();
    animate();
  }
}

float bands[] = new float[7];
void createBands() {
  float[] f = freqValues;
  bands[0] = max(subset(f, 0, 2));
  bands[1] = max(subset(f, 2, 4));
  bands[2] = max(subset(f, 7, 12));
  bands[3] = max(subset(f, 20, 14));
  bands[4] = max(subset(f, 35, 24));
}

int initialOffset = 10;
int barWidth = 15;
int barMargin = 5;
int barStartY = 10;

int hueOffset = 0;
int hueTimer = millis();

void animate()
{
  if (millis() < timeOctaves + 20) {
    return;
  }
  timeOctaves = millis();
  background(0);
  
  drawBars(freqValues);
  //drawLeds();
  //drawSteffenPetrick();
  //drawMovement();
  drawOctaves();
  
  if (millis() > hueTimer + 1000) {
    hueTimer = millis();
    //hueOffset = (hueOffset+1)%360;
  }
}

int[] octaveC = {65, 130, 260, 520, 1040, 2080};
int[] octaveCbin = {1, 3, 6, 12, 24, 48};
//int[] octaveCbin = {1, 3, 6, 12, 24, 48};
int[][] octaves = {
  new int[2], 
  new int[3],
  new int[6],
  new int[12],
  new int[24]
};
int octaveLedLength = 40;
color[][] octaveLeds = {new color[octaveLedLength], new color[octaveLedLength], new color[octaveLedLength], new color[octaveLedLength], new color[octaveLedLength]};

void drawOctaves() {
  for (int octaveIndex = 0; octaveIndex < octaveLeds.length; octaveIndex++) {
    drawOctave(octaveIndex);
  }
}

int timeOctaves = millis();

void drawOctave(int octaveIndex) {
  colorMode(HSB, 360, 255, 255);
  
  color[] leds = octaveLeds[octaveIndex];
  int startBin = octaveCbin[octaveIndex];
  int numBins = octaveCbin[octaveIndex+1] - startBin;
  //numBins *= 2;
  if (startBin + numBins > freqValues.length) {
    numBins = freqValues.length - startBin;
  }
  float[] relevantFreqs = subset(freqValues, startBin, numBins);
  float maxFreq = max(relevantFreqs);
  float strength = maxFreq * (1 + octaveIndex/2);  //boost higher octaves
  
  if (strength < 0.3) {
    //strength = 0;
  }
  
  //float avg = average(relevantFreqs);
  
  int maxFreqIndex = indexOf(relevantFreqs, maxFreq);
  int hue = 360*maxFreqIndex / relevantFreqs.length;
  hue = 240 - hue + hueOffset;
  if (hue < 0) {
    hue += 360;
  }
  //println("hue", hue);
  
  leds[0] = color(hue, 255, strength*255); 
  showStrip(leds, ((ledSize+10)*octaveLeds.length) - octaveIndex * (ledSize+10));
  
  for (int i=leds.length-1; i>0; i--) {
    leds[i] = leds[i-1];
  }
  fadeDownHSB(leds, 8);
  //fadeDown(leds, 8);
}

int indexOf(float[] ar, float val) {
  for (int i=0; i<ar.length; i++) {
    if (ar[i] == val) {
      return i;
    }
  }
  return -1;
}

void fadeDownHSB(color[] leds, int fadeBy) {
  for (int i=0; i<leds.length; i++) {
    color c = leds[i];
    leds[i] = color(hue(c), saturation(c), brightness(c)*(255-fadeBy)/255);
  }
}

void showStrip(color[] leds, int startY) {
  for (int i=0; i<leds.length; i++) {
    fill(leds[i]);
    rect(5 + i*(ledSize+5), startY, ledSize, ledSize);
  }
}

color[] leds = new color[60];

int time1 = millis();
int time2 = millis();

void drawMovement() {
  //if (millis() > time1 + 2000) {
    //time1 = millis();
  //}
  showLeds();
  if (millis() > time2 + 30) {
    leds[0] = color(0, 0, bands[2]*255*2);
    for (int i = leds.length - 1; i > 0; i--) {
      leds[i] = leds[i-1];
    }  
    fadeDown();
  }
}

int time = millis();
void drawSteffenPetrick() 
{
  colorMode(RGB);
  showLeds();
  if (millis() < time + 30) {
    return;
  }
  time = millis();
  for (int i = leds.length - 1; i > 0; i--) {
    leds[i] = leds[i-1];
  }
  leds[0] = color(bands[4]*2*255, bands[3]*2*255, bands[1]*255);
  showLeds();
  fadeDown();
}

void showLeds() 
{
  for (int i = 0; i < leds.length; i++) {
    fill(leds[i]);
    rect(5 + i * (ledSize+5), 5, ledSize, ledSize);
  }
}

int fadeBy = 4;
void fadeDown() {
  fadeDown(leds, fadeBy);
}

void fadeDown(color[] leds, int fadeBy) {
  for (int i = 0; i < leds.length; i++) {
    color current = leds[i];
    int r = int(red(current));
    int g = int(green(current));
    int b = int(blue(current));
    leds[i] = color(fade(r, fadeBy), fade(g, fadeBy), fade(b, fadeBy)); 
  }
}

int fade(int v, int fadeBy) {
  return int((255 - fadeBy) * v / 255);
}

int numLeds = 60;
int ledSize = 20;
void drawLeds()
{
  for (int i = 0; i < numLeds; i++) {
    int blue = int(freqValues[i] * 255 * 10);
    blue = constrain(blue, 0, 255);
    println("blue:", blue);
    color c = color(0, 0, blue);
    fill(c);
    rect(5 + i * (ledSize+5), 5, ledSize, ledSize);
  }
}

void drawBars(float[] values)
{
  fill(255);
  for (int i = 0; i < values.length; i++) {
    int barHeight = int((canvasHeight - barStartY*2) * values[i]);
    rect(initialOffset + i*(barWidth+barMargin), canvasHeight - barStartY - barHeight, barWidth, canvasHeight - barStartY);
  }
}

void readFreqs()
{
  String[] values = myString.split(" ");
  if (values.length < freqValues.length) {
    return;
  }
  //printArray(values);
  for (int i = 1; i < freqValues.length; i++) {
   freqValues[i] = float(values[i]); 
  }
  //printArray(freqValues);
}

void initPort() 
{
  String matchingPortPrefix = "/dev/cu.usbmodem";
  for (String port : Serial.list()) {
    String prefix = port.substring(0, matchingPortPrefix.length());
    if (prefix.equals(matchingPortPrefix)) {
      println("Connecting to:", port);
      myPort = new Serial(this, port, 250000);
      return;
    }
  }
  println(">>>>>>>>>>>>> Couldn't find port! <<<<<<<<<<<<<<<");
}