import processing.serial.*;

class TeensyFFT {
  static final int NUM_FREQS = 140;
  Serial myPort;
  String myString;
  float[] freqValues = new float[NUM_FREQS];
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
  color[][] teensyLeds = new color[8][];
  
  void setup(PApplet app) {
    initPort(app);
    
    for (int i = 0; i < 5; i++) {
      octaveLeds[i] = new color[LEDS];
    }
    
    for (int i = 0; i < 8; i++) {
      pixelLeds[i] = new color[LEDS];
    }
    
    for (int i = 0; i < 8; i++) {
      teensyLeds[i] = new color[LEDS];
    }
  }
  
  float[] averages = new float[TeensyFFT.NUM_FREQS];
  float[] deltas = new float[TeensyFFT.NUM_FREQS];
  
  float[] origFreqs = new float[TeensyFFT.NUM_FREQS];
  float[] deltaBands = new float[6];
  float[] averageBands = new float[6];
  
  int frames = 0;
  int startMillis = millis();
  void update() {
    colorMode(HSB, 360, 255, 255);
    
    while (myPort.available() > 0) {
      myString = myPort.readStringUntil(10);
      if (myString == null) {
        continue;
      }
      //readFreqs(freqValues);
    
      //saveOrigFreqs();
      
      //rollingSmooth(freqValues, 0.7);
      //adjustHumanEar(freqValues);
      //rollingScaleToMax(freqValues);
      //exaggerate(freqValues, 2);
      
      //normalizeSum(freqValues);
      
      //calcDeltasAndAverages(freqValues, 0.8);
      //deltas = freqValues;
      //deltaBands = createBands(deltas);
      //averageBands = createBands(averages);
      readFreqs(deltaBands);
      animate();
      
      //readLedsFromTeensy(teensyLeds);
      //pixelLeds = teensyLeds;
      //audio2.moveStrips(pixelLeds, 0);
      //println(teensyLeds[0][0]);
      
      frames++;
      if (millis() > startMillis + 1000) {
        startMillis = millis();
        println("FFT FPS: ", frames);
        frames = 0;
      }
    }
    
    colorMode(RGB);
  }
  
  void saveOrigFreqs() {
    for (int i=0; i<freqValues.length; i++) {
      origFreqs[i] = freqValues[i];
    }
  }
  
  float averageFactor = 0.95;
  void calcDeltasAndAverages(float[] freqValues, float deltaFactor) {
    for (int i = 0; i < freqValues.length; i++) {
      averages[i] = averages[i] * averageFactor + freqValues[i] * (1 - averageFactor);
      deltas[i] = max(freqValues[i] - averages[i]*deltaFactor, 0);
    }
  }
  
  float[] smoothFreqValues = new float[NUM_FREQS];
  void rollingSmooth(float[] freqValues, float smoothFactor) {
    for (int i = 0; i < freqValues.length; i++) {
      float value = smoothFreqValues[i] * smoothFactor + freqValues[i] * (1 - smoothFactor);
      smoothFreqValues[i] = value;
      freqValues[i] = value;
    }
  }
  
  void normalizeSum(float[] freqValues) {
    float sum = U.sum(freqValues);
    if (sum == 0) return;
    
    for (int i = 0; i < freqValues.length; i++) {
      freqValues[i] = (freqValues[i]/sum) * 8;
    }
  }
  
  float avgPeak = 0.0;
  float falloff = 0.9;
  void rollingScaleToMax(float[] freqValues) {
    float peak = max(freqValues);
    if (peak > avgPeak) {
      avgPeak = peak;
    } else {
      avgPeak *= falloff;
      avgPeak += peak * (1 - falloff);
    }
    if (avgPeak == 0) {
      return;
    } else {
      for (int i = 0; i < freqValues.length; i++) {
        freqValues[i] /= avgPeak;
      }
    }
  }
  
  void exaggerate(float[] freqValues, float exponent) {
    for (int i = 0; i < freqValues.length; i++) {
      freqValues[i] = pow(freqValues[i], exponent);
    }
  }
  
  HumanAdjuster humanAdjuster = new HumanAdjuster();
  void adjustHumanEar(float[] freqValues) {
    humanAdjuster.adjust(freqValues);
  }
  
  void animate() {
    //drawBeam();
    //drawAudio1();
    drawAudio2();
    //drawAudio3();
    //drawAudio4();
    /*
    for (int octaveIndex = 0; octaveIndex < octaveLeds.length; octaveIndex++) {
      drawOctave(octaveIndex);
    }
    */
  }
  
  Audio1 audio1 = new Audio1();
  void drawAudio1() {
    audio1.draw(pixelLeds, freqValues);
  }
  
  Audio2 audio2 = new Audio2();
  void drawAudio2() {
   audio2.draw(pixelLeds, freqValues, deltas, averages, deltaBands);
  }
  
  Audio3 audio3 = new Audio3();
  void drawAudio3() {
   audio3.draw(pixelLeds, deltaBands, averageBands);
  }
  
  Audio4 audio4 = new Audio4();
  void drawAudio4() {
   audio4.draw(pixelLeds, deltaBands);
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
  
  int[][] bandsGrouping = {{0,2}, {3,4}, {8,8}, {17,17}, {35,24}, {60,80}};
  
  float[] createBands(float[] f) {
    float bands[] = new float[6];
    for (int i = 0; i < 6; i++) {
      bands[i] = processBand(subset(f, bandsGrouping[i][0], bandsGrouping[i][1]));
    }
    return bands;
  }
  
  float processBand(float[] ar) {
    return pow(max(ar), 1);
  }
  
  float sineSum(float[] ar) {
    float s = 0;
    for (int i = 0; i < ar.length; i++) {
      s += ar[i] * sin(PI*(i+1)/ar.length);
    }
    return s;
  }
  
  void readFreqs(float[] ar) {
    String[] values = myString.split(" ");
    if (values.length < ar.length) {
      return;
    }
    
    for (int i = 0; i < ar.length; i++) {
     ar[i] = float(values[i]); 
    }
  }
  
  void readLedsFromTeensy(color[][] leds) {
    String[] values = myString.split(" ");
    int valuesPerStrip = values.length / 8;
    
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < valuesPerStrip; j++) {
        leds[i][j] = 0xFF000000 + int(values[i*valuesPerStrip + j]);
      }
    }
    //println(leds[0]);
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
    exit();
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