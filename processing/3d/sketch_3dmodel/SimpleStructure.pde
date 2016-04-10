
class SimpleStructure {
  
  void drawStructure(color[][] leds) {
    for (int i = 0; i < leds.length; i++) {
      drawStrip(i, leds[i]);
    }
  }
  
  void drawStrip(int stripNum, color[] leds) {
    for (int i = 0; i < leds.length; i++) {
      fill(leds[i]);
      int ledSize = 6;
      int ledHSpacing = 0;
      int ledVSpacing = 10;
      int topMargin = 15;
      rect(i * (ledSize + ledHSpacing), topMargin + stripNum * (ledSize + ledVSpacing), ledSize, ledSize);
    }
  }
  
  int initialOffset = 10;
  int barWidth = 10;
  int barMargin = 5;
  int barStartY = 10;
  
  void drawBars(float[] freqValues) {
    fill(255);
    
    for (int i = 0; i < freqValues.length; i++) {
      float barHeight = (int((height - barStartY*2) * freqValues[i]))*0.5;
      rect(initialOffset + i*(barWidth+barMargin), height - barStartY - barHeight, barWidth, height - barStartY);
    }
  }
}