
class Audio4 {
  
  float[] bands = new float[6];
  
  void draw(color[][] pixelLeds, float[] deltaBands) {
    colorMode(RGB, 255, 255, 255, 255);
    smoothen(deltaBands);
    float bass = bands[0];
    
    fadeOut(pixelLeds);
    
    for (int i = 10; i < pixelLeds[0].length; i += 40) {
      drawCircle(pixelLeds[0], i, bass, color(255, 0, 0));
      drawCircle(pixelLeds[2], i+15, bass, color(255, 0, 0));
      drawCircle(pixelLeds[4], i+32, bass, color(255, 0, 0));
      drawCircle(pixelLeds[6], i+8, bass, color(255, 0, 0));
      
      drawCircle(pixelLeds[1], i+5, bands[5], color(255, 0, 255));
      drawCircle(pixelLeds[3], i+20, bands[5], color(255, 0, 255));
      drawCircle(pixelLeds[5], i+37, bands[5], color(255, 0, 255));
      drawCircle(pixelLeds[7], i+13, bands[5], color(255, 0, 255));
      
      drawCircle(pixelLeds[0], i+17, bands[2], color(0, 255, 255));
      drawCircle(pixelLeds[2], i+32, bands[2], color(0, 255, 255));
      drawCircle(pixelLeds[4], i+9, bands[2], color(0, 255, 255));
      drawCircle(pixelLeds[6], i+25, bands[2], color(0, 255, 255));
    }
  }
  
  float smoothFactor = 0.8;
  void smoothen(float[] deltaBands) {
    for (int i = 0; i < deltaBands.length; i++) {
      bands[i] = bands[i] * smoothFactor + deltaBands[i] * (1 - smoothFactor);
    }
  }
  
  void drawCircle(color[] strip, int i, float energy, color baseColor) {
    if (i > strip.length) return;
    
    float e = (1-energy)*255;
    color startColor = fade(baseColor, e);
    strip[i] += startColor;
    for (int j = 1; j < 10 && (i+j) < strip.length; j++) {
      color c = fade(startColor, 255 * j/10);
      strip[i+j] += c;
      strip[i-j] += c;
    }
  }
  
  color fade(color c, float fadeBy) {
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    float fade = (255-fadeBy)/255;
    
    return color(r*fade, g*fade, b*fade);
  }
  
  void fadeOut(color[][] pixelLeds) {
    for (int i = 0; i < pixelLeds.length; i++) {
      color[] strip = pixelLeds[i];
      for (int j = 0; j < strip.length; j++) {
        strip[j] = fade(strip[j], 60);
      }
    }
  }
}