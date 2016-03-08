#define USE_OCTOWS2811
#include<OctoWS2811.h>
#include<FastLED.h>

#define NUM_LEDS_PER_STRIP 64
#define NUM_STRIPS 8

CRGB leds[NUM_STRIPS * NUM_LEDS_PER_STRIP];

// Pin layouts on the teensy 3:
// OctoWS2811: 2,14,7,8,6,20,21,5

void setup() {
  LEDS.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);
}

int frames = 0;

void loop() {
//  fill_rainbow(leds, NUM_STRIPS * NUM_LEDS_PER_STRIP, 0);
  FastLED.show();

  frames++;
  EVERY_N_MILLIS(1000) {
    Serial.print("FastLED.getFPS: ");
    Serial.print(FastLED.getFPS());
    Serial.print("   manual FPS: ");
    Serial.println(frames);
    frames = 0;
  }
}
