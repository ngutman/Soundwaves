
class BeamAnimation {
  int beamMillis = millis();
  int tailLength = 40;
  void drawBeam(color[][] pixelLeds) {
    cleanLeds(pixelLeds);
    
    int beamSpeed = 1000;
    int timePassed = millis() - beamMillis;
    int beamPosition = getBeamPosition(timePassed, beamSpeed);
    drawBeamAtPosition(beamPosition, pixelLeds);
    int beamPosition2 = getBeamPosition(timePassed + beamSpeed/2, beamSpeed);
    drawBeamAtPosition(beamPosition2, pixelLeds);
  }
  
  int getBeamPosition(int timePassed, int beamSpeed) {
    int position = LEDS * (timePassed % beamSpeed) / beamSpeed;
    position += tailLength; //continue the tail even after the beam is off screen
    return position;
  }
  
  void drawBeamAtPosition(int beamPosition, color[][] pixelLeds) {
    for (int i = 0; i < pixelLeds.length; i++) {
      color[] strip = pixelLeds[i];
      for (int j = 0; j < strip.length; j++) {
        if (j > beamPosition || beamPosition > j + tailLength) {
          continue;
        }
        int distance = min(beamPosition - j, tailLength);
        int brightness = 255 * (tailLength - distance) / tailLength;
        strip[j] = color(265, 174, brightness);
      }
    }
  }
  
  void cleanLeds(color[][] pixelLeds) {
    for (int i = 0; i < pixelLeds.length; i++) {
      color[] strip = pixelLeds[i];
      for (int j = 0; j < strip.length; j++) {
        strip[j] = color(0, 0, 0);
      }
    }
  }
}