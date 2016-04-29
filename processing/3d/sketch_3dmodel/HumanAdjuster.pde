
class HumanAdjuster {
  
  int[] humanFreqs =      {0,  50, 100, 200, 500, 1000, 2000, 5000, 10000, 15000, 20000};
  int[] humanCorrection = {-4, -4,  -4,   -2,   2,    2,    2,    4,    -4,     0,    -4};
  
  float[] humanMultipliers = new float[TeensyFFT.NUM_FREQS];
  
  HumanAdjuster() {
    for (int i = 0; i < TeensyFFT.NUM_FREQS; i++) {
      int freq = (int) (i*43.066);
      float multiplier = getHumanMultiplier(freq);
      humanMultipliers[i] = multiplier;
    }
    //printArray(humanMultipliers);
  }
  
  void adjust(float[] freqValues) {
    for (int i = 0; i < freqValues.length; i++) {
      freqValues[i] = freqValues[i] * humanMultipliers[i];
    }
  }
  
  float getHumanMultiplier(int freq) {
    int x1 = 0, x2 = 0, y1 = 0, y2 = 0;
    for (int i = 0; i < humanFreqs.length - 1; i++) {
      if ((freq >= humanFreqs[i]) && (freq < humanFreqs[i+1])) {
        x1 = humanFreqs[i];
        x2 = humanFreqs[i+1];
        y1 = humanCorrection[i];
        y2 = humanCorrection[i+1];
        break;
      }
    }
    int decibels = ((x2-freq)*y1 + (freq-x1)*y2)/(x2-x1);
    return pow(10.0, (decibels/10.0));
  }
}