import processing.serial.*;

class TeensyFFT {
  Serial myPort;
  String myString;
  float bands[] = new float[7];
  float[] freqValues = new float[60];
  int[] octaveC = {65, 130, 260, 520, 1040, 2080};
  int[] octaveCbin = {1, 3, 6, 12, 24, 48};
  int hueOffset = 0;
  
  int[][] octaves = {
    new int[2], 
    new int[3],
    new int[6],
    new int[12],
    new int[24]
  };
  
  color[][] octaveLeds = new color[5][];
  
  color[][] pixelLeds = new color[8][];
  
  void setup(PApplet app) {
    initPort(app);
    
    for (int i = 0; i < 5; i++) {
      octaveLeds[i] = new color[LEDS];
    }
    
    for (int i = 0; i < 8; i++) {
      pixelLeds[i] = new color[LEDS];
    }
  }
  
  void update() {
    colorMode(HSB, 360, 255, 255);
    
    while (myPort.available() > 0) {
      myString = myPort.readStringUntil(10);
      if (myString == null) {
        continue;
      }
      readFreqs();
      createBands();
      animate();
    }
    
    colorMode(RGB);
  }
  
  void animate() {
    drawBeam();
    /*
    for (int octaveIndex = 0; octaveIndex < octaveLeds.length; octaveIndex++) {
      drawOctave(octaveIndex);
    }
    */
  }
  
  BeamAnimation beamAnimation = new BeamAnimation();
  void drawBeam() {
    beamAnimation.drawBeam(pixelLeds);
  }
  
  void drawOctave(int octaveIndex) {    
    color[] leds = octaveLeds[octaveIndex];
    int startBin = octaveCbin[octaveIndex];
    int numBins = octaveCbin[octaveIndex+1] - startBin;
    
    if (octaveIndex > 0) {
      for (int i = 0; i < leds.length; i++) {
        leds[i] = color(0, 0, 0);
      }
      return;
    }
    
    if (startBin + numBins > freqValues.length) {
      numBins = freqValues.length - startBin;
    }
    
    float[] relevantFreqs = subset(freqValues, startBin, numBins);
    //println(join(nf(relevantFreqs), " "));
    float maxFreq = max(relevantFreqs);
    float strength = maxFreq * (1 + octaveIndex/2);  //boost higher octaves

    int maxFreqIndex = indexOf(relevantFreqs, maxFreq);
    int hue = 360*maxFreqIndex / relevantFreqs.length;
    hue = 240 - hue + hueOffset;
    if (hue < 0) {
      hue += 360;
    }
    
    leds[0] = color(hue, 255, strength*255); 
    
    for (int i=leds.length-1; i>0; i--) {
      leds[i] = leds[i-1];
    }
    fadeDownHSB(leds, 0);
  }
  
  void fadeDownHSB(color[] leds, int fadeBy) {
    for (int i=0; i<leds.length; i++) {
      color c = leds[i];
      leds[i] = color(hue(c), saturation(c), brightness(c)*(255-fadeBy)/255);
    }
  }
  
  void createBands() {
    float[] f = freqValues;
    bands[0] = max(subset(f, 0, 2));
    bands[1] = max(subset(f, 2, 4));
    bands[2] = max(subset(f, 7, 12));
    bands[3] = max(subset(f, 20, 14));
    bands[4] = max(subset(f, 35, 24));
  }
  
  void readFreqs() {
    String[] values = myString.split(" ");
    if (values.length < freqValues.length) {
      return;
    }
    
    for (int i = 0; i < freqValues.length; i++) {
     freqValues[i] = float(values[i]); 
    }
  }

  float[] getFreqValues() {
    return freqValues;
  }
  
  void initPort(PApplet app) {
    String matchingPortPrefix = "/dev/cu.usbmodem";
    for (String port : Serial.list()) {
      String prefix = port.substring(0, matchingPortPrefix.length());
      if (prefix.equals(matchingPortPrefix)) {
        println("Connecting to:", port);
        myPort = new Serial(app, port, 250000);
        return;
      }
    }
    println(">>>>>>>>>>>>> Couldn't find port! <<<<<<<<<<<<<<<");
  }
  
  color[] getStrip(int strip) {
    return pixelLeds[strip];
    
    /*
    return octaveLeds[strip % 5];
    */
  }
  
  int indexOf(float[] ar, float val) {
    for (int i=0; i<ar.length; i++) {
      if (ar[i] == val) {
        return i;
      }
    }
    return -1;
  }
}