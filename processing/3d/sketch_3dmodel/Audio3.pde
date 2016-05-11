
class Audio3 extends BaseAnimation {
  void draw(color[][] pixelLeds, float[] bands, float[] averageBands) {
    pixelLeds[0][0] = color(getHue(0), 150, 255*bands[0]*2);
    pixelLeds[1][0] = color(getHue(60), 150, 255*bands[1]);
    pixelLeds[2][0] = color(getHue(240), 150, 255*(bands[3]+bands[2]));
    pixelLeds[3][0] = color(getHue(300), 150, 255*(bands[4]+bands[5]));
    mirrorStrips(pixelLeds);
    
    int pixelsPerSecond;
    if (bands[0] > 0.2) {
      pixelsPerSecond = int(map(averageBands[0], 0, 1, 100, 400));
    } else {
      pixelsPerSecond = 100;
    }
    moveStrips(pixelLeds, 0, pixelsPerSecond);
    
    fill(255);
    text("speed: " + pixelsPerSecond, 0, 150);
  }
}