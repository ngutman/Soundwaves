#ifndef ANIMATIONS_H
#define ANIMATIONS_H

uint8_t hueShift = 0;

uint8_t getHue(uint8_t hue) {
//  EVERY_N_MILLIS(150) {
//    hueShift++;
//  }
  
  return hue + hueShift;
}

void shiftArrayRight(CRGB leds[], int moveBy, int startIndex) {
  for (int i = NUM_LEDS_PER_STRIP - 1; i >= moveBy + startIndex; i--) {
    leds[i] = leds[i - moveBy];
  }
}

void moveStrips(CRGB leds[], int startIndex) {
  EVERY_N_MILLIS(5*6) {
    for (int i = 0; i < NUM_STRIPS; i++) {
      shiftArrayRight(&leds[i*NUM_LEDS_PER_STRIP], 1, startIndex);
    }
  }
}

void mirrorStrips(CRGB leds[]) {
  leds[NUM_LEDS_PER_STRIP*7] = leds[0];
  leds[NUM_LEDS_PER_STRIP*6] = leds[NUM_LEDS_PER_STRIP];
  leds[NUM_LEDS_PER_STRIP*5] = leds[NUM_LEDS_PER_STRIP*2];
  leds[NUM_LEDS_PER_STRIP*4] = leds[NUM_LEDS_PER_STRIP*3];
}

uint8_t getValue(int value) {
  return min(value, 255);
}

void bandsAnimation(float bands[], CRGB leds[]) {
  leds[0] = CHSV(getHue(0), 150, getValue(255*bands[0]*2));
  leds[NUM_LEDS_PER_STRIP] = CHSV(getHue(43), 200, getValue(255*bands[1]));
  leds[NUM_LEDS_PER_STRIP*2] = CHSV(getHue(170), 200, getValue(255*(bands[3]+bands[2])));
  leds[NUM_LEDS_PER_STRIP*3] = CHSV(getHue(213), 200, getValue(255*(bands[4]+bands[5])));

  mirrorStrips(leds);
  moveStrips(leds, 0);
}

#endif
