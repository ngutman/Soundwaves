
class BeamAnimation {
  int beamMillis = millis();
  void drawBeam(color[][] pixelLeds) {
    int beamSpeed = 500;
    int timePassed = millis() - beamMillis;
    int beamPosition = LEDS * (timePassed % beamSpeed) / beamSpeed;
    for (int i = 0; i < pixelLeds.length; i++) {
      color[] strip = pixelLeds[i];
      for (int j = 0; j < strip.length; j++) {
        if (j > beamPosition) {
          strip[j] = color(265, 174, 0);
          continue;
        }
        int tailLength = 40;
        int distance = min(beamPosition - j, tailLength);
        int brightness = 255 * (tailLength - distance) / tailLength;
        strip[j] = color(265, 174, brightness);
      }
    }
  }
}