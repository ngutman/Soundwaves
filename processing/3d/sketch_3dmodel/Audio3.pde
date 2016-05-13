
class Audio3 extends BaseAnimation {
  
  int beatInterval = -1;
  float bpm = 0;
  float rollingBpm;
  
  void draw(color[][] pixelLeds, float[] bands, float[] averageBands) {
    pixelLeds[0][0] = color(getHue(0), 150, 255*bands[0]*2);
    pixelLeds[1][0] = color(getHue(60), 150, 255*bands[1]);
    //pixelLeds[2][0] = color(getHue(240), 150, 255*(bands[3]+bands[2]));
    //pixelLeds[3][0] = color(getHue(300), 150, 255*(bands[4]+bands[5]));
    pixelLeds[2][0] = color(getHue(240), 150, 255*2*(bands[3]+bands[4]));
    pixelLeds[3][0] = color(getHue(300), 150, 255*(bands[5]));
    mirrorStrips(pixelLeds);
    
    detectPeaks(bands[0]);
    
    int pixelsPerSecond;
    int minSpeed = 150;
    int maxSpeed = 450;
    float threshold = 0;
    if ((abs(bpm - rollingBpm) < 4) && (bands[0] > threshold)) {
      pixelsPerSecond = int(map(bands[0], threshold, 1, minSpeed, maxSpeed));
    } else {
      pixelsPerSecond = minSpeed;
    }
    moveStrips(pixelLeds, 0, pixelsPerSecond);
    
    fill(255);
    text("speed: " + pixelsPerSecond, 0, 150);
    //println("speed: " + pixelsPerSecond);
    
  }
  
  float vals[] = new float[300];
  int j = 0;
  int lastPeak = 0;
  int usedJ = 0;
  int detectPeaks(float value) {
    vals[j] = value;
    usedJ = j;
    j = (j+1) % vals.length;
    if (U.sum(vals) < 20) return -1;
    //println(millis() + " good sum=" + U.sum(vals));
    
    float maxd = -1000.0;
    int maxI = -1;
    float[] fl = new float[75-20];
    for (int i = 20; i < 75; i++) {
      float d = calcDist(subset(vals, 0, vals.length/2), subset(vals, i, vals.length/2));
      fl[i-20] = d;
      if (d > maxd) {
        maxd = d;
        maxI = i;
      }
    }
    
    //println(join(nf(subset(reverse(sort(fl)), 0, 5)), ","));
    bpm = 60000/(maxI*11.5);
    rollingBpm = bpm * 0.005 + rollingBpm * 0.995;
    
    println(millis() + "   maxd=" + maxd + " maxI=" + maxI + " bpm=" + bpm + " rbpm=" + rollingBpm);
    
    return maxI;
  }
  
  float calcDist(float[] a1, float[] a2) {
    float s = 0;
    for (int i = 0; i < a1.length; i++) {
      s += -pow((a1[i] - a2[i]),2);
      //s += a1[i] * a2[i];
    }
    return s;
  }
}