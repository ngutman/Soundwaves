#define USE_OCTOWS2811
#include<OctoWS2811.h>
#include<FastLED.h>
#include <Audio.h>

#define NUM_LEDS_PER_STRIP 120
#define NUM_STRIPS 8

CRGB leds[NUM_STRIPS * NUM_LEDS_PER_STRIP];

AudioInputI2S          audioInput;         // audio shield: mic or line-in
AudioAnalyzePeak         peak1;
AudioConnection patchCord1(audioInput, 0, peak1, 0);
AudioControlSGTL5000 audioShield;

// Pin layouts on the teensy 3:
// OctoWS2811: 2,14,7,8,6,20,21,5

void setup() {
  Serial.println("Begin setup");
  LEDS.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);
  LEDS.setBrightness(40);

  AudioMemory(12);
  Serial.println("Before enable");
  audioShield.enable();
  Serial.println("After enable");
  audioShield.inputSelect(AUDIO_INPUT_LINEIN);
  audioShield.volume(0.5);

  Serial.println("End setup");
}

elapsedMillis fps;

void loop() {
  float n;
  int i;
  float peak;
  int hue = 0;

  if (fps > 24) {
    if (peak1.available()) {
      fps = 0;
      peak = peak1.read();
      Serial.print("|");
      for (int cnt=0; cnt < (peak*30); cnt++) {
        Serial.print(">");
      }
      Serial.println();
    }

    fill_solid(leds, NUM_LEDS_PER_STRIP, CRGB::Black);
    fill_solid(leds, NUM_LEDS_PER_STRIP * peak, CRGB::Blue);
    AudioNoInterrupts();
    LEDS.show();
    AudioInterrupts();
  }
 
}
