
class SimpleStructure {
  
  void drawStructure(color[][] leds) {
    for (int i = 0; i < leds.length; i++) {
      drawStrip(i, leds[i]);
    }
  }
  
  void drawStrip(int stripNum, color[] leds) {
    for (int i = 0; i < leds.length; i++) {
      fill(leds[i]);
      int ledSize = 3;
      int ledSpacing = 2;
      rect(i * (ledSize + ledSpacing), stripNum * (ledSize + ledSpacing), ledSize, ledSize);
    }
  }
}