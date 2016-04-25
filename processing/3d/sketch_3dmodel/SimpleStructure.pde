
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
  int barStartY = 0;
  
  void drawBars(float[] freqValues) {
    fill(255);
    //drawBarsInternal(freqValues);
  }
  void drawBarsInternal(float[] freqValues) {
    float lastX = initialOffset;
    float lastWidth = 0;
    for (int i = 0; i < freqValues.length; i++) {
      float barHeight = (int((height - barStartY*2) * freqValues[i]))*0.5;
      float adjustedWidth = barWidth * (1/pow((i+1),0.5)); 
      rect(lastX + lastWidth + barMargin, height - barStartY - barHeight, adjustedWidth, height - barStartY);
      lastX = lastX + lastWidth + barMargin;
      lastWidth = adjustedWidth;
    }
    
  }
  
  float[] averages = new float[TeensyFFT.NUM_FREQS];
  float[] deltas = new float[TeensyFFT.NUM_FREQS];
  float averageFactor = 0.99;
  void drawAverages(float[] freqValues) {
    for (int i = 0; i < freqValues.length; i++) {
      averages[i] = averages[i] * averageFactor + freqValues[i] * (1 - averageFactor);
      deltas[i] = max(freqValues[i] - averages[i], 0);
    }
    
    fill(150);
    //drawBarsInternal(averages);
    drawBarsInternal(deltas);
  }
  
  
}