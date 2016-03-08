#include "FastLED.h"

#define NUM_LEDS 512
#define DATA_PIN 3
CRGB leds[NUM_LEDS];

void setup() {
//  FastLED.addLeds<WS2812B, DATA_PIN, RGB>(leds, NUM_LEDS);
  FastLED.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);
}

int frames = 0;

void loop() {
  fill_rainbow(leds, NUM_LEDS, 0);
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
