
class Audio2 {
  
  float bassValue = 0;
  int x = 0;
  float lastBass = 0;
  void draw(color[][] pixelLeds, float[] freqValues, float[] deltas, float[] averages, float[] bands) {
    //float bass = bands[0];
    //color color1 = color(0, 150, 255*bass*2);
    //pixelLeds[0][0] = color1;
    //pixelLeds[0][0] = color((0*bands[0] + 50*bands[1])/(bands[0]+bands[1]), 150, 255*(bands[1]+bands[0]));
    pixelLeds[0][0] = color(0, 150, 255*bands[0]*2);
    //pixelLeds[1][0] = color(180, 150, 255*bands[2]*2);
    pixelLeds[1][0] = color(60, 150, 255*bands[1]*2);
    //pixelLeds[2][0] = color(240, 150, 255*bands[3]*2);
    pixelLeds[2][0] = color(240, 150, 255*bands[3]+bands[2]);
    pixelLeds[3][0] = color(300, 150, 255*(bands[4]+bands[5]));
    mirrorStrips(pixelLeds);
    
    moveStrips(pixelLeds, 0);
  }
  
  void mirrorStrips(color[][] pixelLeds) {
    pixelLeds[7][0] = pixelLeds[0][0];
    pixelLeds[6][0] = pixelLeds[1][0];
    pixelLeds[5][0] = pixelLeds[2][0];
    pixelLeds[4][0] = pixelLeds[3][0];
  }
  
  int lastMove = millis();
  int movePixelEveryMillis = 5;
  void moveStrips(color[][] pixelLeds, int startIndex) {
    int timePassed = millis() - lastMove;
    if (timePassed < movePixelEveryMillis) {
      return;
    } else {
      lastMove = millis();
      int moveBy = timePassed / movePixelEveryMillis;
      for (int i = 0; i < pixelLeds.length; i++) {
        shiftArrayRight(pixelLeds[i], moveBy, startIndex);
      }
    }
  }
  
  void shiftArrayRight(color[] pixelLeds, int moveBy, int startIndex) {
    for (int i = pixelLeds.length - 1; i >= moveBy + startIndex; i--) {
      pixelLeds[i] = pixelLeds[i - moveBy];
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