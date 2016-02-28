#define USE_OCTOWS2811
#include <OctoWS2811.h>
#include <FastLED.h>
#include <Audio.h>
#include "Channel.h"

#define NUM_LEDS_PER_STRIP 120
#define NUM_STRIPS 8
#define NUM_LEVELS 16

CRGB leds[NUM_STRIPS * NUM_LEDS_PER_STRIP];

AudioInputI2S          audioInput;         // audio shield: mic or line-in
AudioAnalyzeFFT256    myFFT;
AudioConnection patchCord1(audioInput, 0, myFFT, 0);
AudioControlSGTL5000 audioShield;

// Pin layouts on the teensy 3:
// OctoWS2811: 2,14,7,8,6,20,21,5

void print_level();
void show_leds();

void setup() {
  LEDS.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);
  LEDS.setBrightness(40);

  AudioMemory(12);
  audioShield.enable();
  audioShield.inputSelect(AUDIO_INPUT_LINEIN);
  audioShield.volume(0.5);
  audioShield.lineInLevel(15);

  Serial.println("End setup");
}

elapsedMillis fps;
float level[NUM_LEVELS];
Channel channels[NUM_LEVELS];
uint8_t outputs[NUM_LEVELS];

void loop() {
  float n;
  int i;
  float peak;
  int hue = 0;

  if (fps > 24) {

    if (myFFT.available()) {
      level[0] = myFFT.read(2);
      level[1] = myFFT.read(3);
      level[2] = myFFT.read(4);
      level[3] = myFFT.read(5, 6);
      level[4] = myFFT.read(7, 8);
      level[5] = myFFT.read(9, 10);
      level[6] = myFFT.read(11, 14);
      level[7] = myFFT.read(15, 19);
      level[8] = myFFT.read(20, 25);
      level[9] = myFFT.read(26, 32);
      level[10] = myFFT.read(33, 41);
      level[11] = myFFT.read(42, 52);
      level[12] = myFFT.read(53, 65);
      level[13] = myFFT.read(66, 82);
      level[14] = myFFT.read(83, 103);
      level[15] = myFFT.read(104, 127);

      for (i = 0; i < NUM_LEVELS; i++) {
        outputs[i] = channels[i].updateAndRead(level[i] * 255);
      }

      print_level();
      show_leds();
    }
  }
}

void show_leds() {
  int i;
  uint8_t leds_per_channel = (NUM_LEDS_PER_STRIP / NUM_LEVELS);

  fill_solid(leds, NUM_LEDS_PER_STRIP, CRGB::Black);

  for (i = 0; i < NUM_LEVELS; i++) {
    int leds_to_show = (outputs[i] / 255.0f)  * leds_per_channel;

    for (int j = 0; j < leds_to_show; j++) {
      leds[i * leds_per_channel + j] = CRGB::Blue;
    }
  }

  LEDS.show();
}

void print_level() {
  int i;
  uint8_t n;

  Serial.print("FFT: ");
  for (i = 0; i < NUM_LEVELS; i++) {
    n = outputs[i];
    if (n >= 0.01) {
      Serial.print(n);
      Serial.print(" \t");
    } else {
      Serial.print("  -  \t"); // don't print "0.00"
    }
  }
  Serial.println();
}

