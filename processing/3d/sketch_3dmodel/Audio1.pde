
class Audio1 {
  
  float rollingMaxAvg = 0;
  
  void draw(color[][] pixelLeds, float[] freqValues) {
    float bass = sumFreqs(freqValues, 0, 3) / 4;
    pixelLeds[0][0] = color(0, 255, 255*bass);
    pixelLeds[2][0] = pixelLeds[0][0];
    smear(pixelLeds[2]);
    
    rollTape(pixelLeds[0]);
    smear(pixelLeds[0]);
    
  }
  
  void smear(color[] strip) {
    color c = strip[0];
    for (int i = 1; i < 20; i++) {
      float multiplier = pow(0.9, i); 
      strip[i] = multiplyBrightness(strip[i], 1-multiplier) + multiplyBrightness(c, multiplier);
    }
  }
  
  color multiplyBrightness(color c, float multiplier) {
    return color(hue(c), saturation(c), brightness(c)*multiplier);
  }
  
  int time = millis();
  int movePixelEveryMillis = 10;
  void rollTape(color[] strip) {
    int millisPassed = (millis() - time);
    if (millisPassed < movePixelEveryMillis) {
      return;
    }
    time = millis();
    int pixelsToMove = millisPassed / movePixelEveryMillis;
    
    for (int i = strip.length - 1; i >= pixelsToMove; i--) {
      strip[i] = strip[i - pixelsToMove];
    }
  }
  
  float sumFreqs(float[] freqValues, int start, int end) {
    float sum = 0.0;
    for (int i = start; i <= end; i++) {
      sum += freqValues[i];
    }
    return sum;
  }
}