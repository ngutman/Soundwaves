
class Audio1 {
  void draw(color[][] pixelLeds, float[] freqValues) {
    pixelLeds[0][0] = color(0, 255, 255*freqValues[1]);
    //println(255*freqValues[1]);
  }
}