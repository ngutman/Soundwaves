
abstract class BaseAnimation {
  int hueShift = 0;
    
  int getHue(int hue) {
    return (hue + hueShift) % 360;
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
    moveStrips(pixelLeds, startIndex, 1000/movePixelEveryMillis);
  }
  
  void moveStrips(color[][] pixelLeds, int startIndex, int pixelsPerSecond) {
    int timePassed = millis() - lastMove;
    int pixelsToMove = (pixelsPerSecond * timePassed) / 1000;
    if (pixelsToMove < 1) {
      return;
    }
    lastMove = millis();
    for (int i = 0; i < pixelLeds.length; i++) {
      shiftArrayRight(pixelLeds[i], pixelsToMove, startIndex);
      fadeTail(pixelLeds[i], 45, 0.95);
    }
  }
  
  void shiftArrayRight(color[] pixelLeds, int moveBy, int startIndex) {
    for (int i = pixelLeds.length - 1; i >= moveBy + startIndex; i--) {
      pixelLeds[i] = pixelLeds[i - moveBy];
    }
  }
  
  void fadeTail(color[] pixelLeds, int tailSize, float fadePerPixel) {
    colorMode(RGB);
    for (int i = 0; i < tailSize; i++) {
      int index = pixelLeds.length - 1 - i;
      color v = pixelLeds[index];
      float r = red(v);
      float g = green(v);
      float b = blue(v);
      pixelLeds[index] = color(r*fadePerPixel, g*fadePerPixel, b*fadePerPixel);
    }
  }
}