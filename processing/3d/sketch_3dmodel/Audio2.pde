
class Audio2 extends BaseAnimation {
  
  float bassValue = 0;
  int x = 0;
  float lastBass = 0;
  
  void draw(color[][] pixelLeds, float[] freqValues, float[] deltas, float[] averages, float[] bands) {
    pixelLeds[0][0] = color(getHue(0), 150, getBrightness(255*bands[0]*2));
    pixelLeds[1][0] = color(getHue(60), 150, getBrightness(255*bands[1]*1.5));
    pixelLeds[2][0] = color(getHue(240), 150, getBrightness(255*1.5*(bands[3]+bands[2])));
    pixelLeds[3][0] = color(getHue(300), 150, getBrightness(255*1.5*(bands[4]+bands[5])));
    mirrorStrips(pixelLeds);
    
    moveStrips(pixelLeds, 0);
    //shiftHue();
  }
  
  int getBrightness(float val) {
    if (val < 50) {
      return 0;
    }
    return min(255, int(val));
  }
  
  int lastHueShift = millis();
  int shiftHueEvery = 150;
  void shiftHue() {
    int timePassed = millis() - lastHueShift;
    if (timePassed < shiftHueEvery) {
      return;
    } else {
      lastHueShift = millis();
      int shiftBy = timePassed / shiftHueEvery;
      hueShift = (hueShift + shiftBy) % 360;
    }
  }
  
  float sumFloats(float[] floats, int start, int end) {
    float sum = 0.0;
    for (int i = start; i <= end; i++) {
      sum += floats[i];
    }
    return sum;
  }
}