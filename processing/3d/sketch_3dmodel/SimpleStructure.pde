
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
  float barWidth = 50;
  int barMargin = 1;
  
  void drawBars(float[] freqValues, float[] origFreqs) {
    drawBarsInternal(freqValues, 255, 150);
    drawBarsInternal(origFreqs, 255, 0);
  }
  
  void drawBands(float[] deltaBands, float[] averageBands) {
    drawBarsInternal(deltaBands, 255, 500);
    
    pushMatrix();
    translate(400, 0);
    drawBarsInternal(averageBands, 255, 500);
    
    translate(300, 270);
    for (int i = 0; i < 6; i++) {
      if ((deltaBands[i]+averageBands[i]) > averageBands[i]*1.3) {
        fill(255);
      } else {
        fill(100);
      }
      rect(0, 0, 30, 30);
      translate(35, 0);
    }
    popMatrix();
  }
  
  void drawBarsInternal(float[] freqValues, int fillColor, int barStartY) {
    float lastX = initialOffset;
    float lastWidth = 0;
    int maxHeight = 100;
    for (int i = 0; i < freqValues.length; i++) {
      float barHeight = maxHeight * freqValues[i];
      float adjustedWidth = barWidth * (1/pow((i+1),0.5));
      fill(fillColor);
      float barYStart = height - barStartY - barHeight;
      rect(lastX + lastWidth + barMargin, barYStart, adjustedWidth, barHeight);
      lastX = lastX + lastWidth + barMargin;
      lastWidth = adjustedWidth;
      fill(200);
      //text(freqValues[i], lastX, 250);
    }
    
  }
  
  void drawAverages(float[] averages, float[] deltas) {
    //drawBarsInternal(averages, 150, 0);
    drawBarsInternal(deltas, 300, 300);
  }
  
  
}