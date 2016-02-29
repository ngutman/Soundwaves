#define USE_OCTOWS2811
#include <OctoWS2811.h>
#include <FastLED.h>
#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

#define NUM_LEDS_PER_STRIP 150
#define NUM_STRIPS 2
#define START_LED 75
#define SIDE_LENGTH 40


CRGB leds[NUM_STRIPS * NUM_LEDS_PER_STRIP];

const int myInput = AUDIO_INPUT_LINEIN;
//const int myInput = AUDIO_INPUT_MIC;

// Create the Audio components.  These should be created in the
// order data flows, inputs/sources -> processing -> outputs
//
AudioInputI2S          audioInput;         // audio shield: mic or line-in
AudioSynthWaveformSine sinewave;
AudioAnalyzeFFT1024    myFFT;
AudioOutputI2S         audioOutput;        // audio shield: headphones & line-out

// Connect either the live input or synthesized sine wave
AudioConnection patchCord1(audioInput, 0, myFFT, 0);

AudioControlSGTL5000 audioShield;

void setup() {
  // Audio connections require memory to work.  For more
  // detailed information, see the MemoryAndCpuUsage example
  AudioMemory(12);

  // Enable the audio shield and set the output volume.
  audioShield.enable();
  audioShield.inputSelect(myInput);
  audioShield.volume(0.5);

  audioShield.lineInLevel(15);

  FastLED.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);
  FastLED.setBrightness(90);
}

float level[16];
elapsedMillis timer;

void print_16_levels();
void print_40_bins();
void animate_stefan_petrick(uint8_t *bands);
void fade_down(uint8_t value);
void print_msgeq7_bands(uint8_t *bands);
void simulate_msgeq7_bands(uint8_t *bands);
void animate_strip(int strip);

uint8_t bands[7];

void loop() {
  if (myFFT.available()) {
    print_40_bins();
  //  print_16_levels();
  
    simulate_msgeq7_bands(bands);
    print_msgeq7_bands(bands);

    EVERY_N_MILLISECONDS(30) {
      animate_stefan_petrick(bands);
    }
  }
}

void simulate_msgeq7_bands(uint8_t *bands) {
  bands[0] = myFFT.read(0, 2) * 255;
  bands[1] = myFFT.read(2, 6) * 255;
  bands[2] = myFFT.read(7, 19) * 255;
  bands[3] = myFFT.read(20, 34) * 255;
  bands[4] = myFFT.read(35, 90) * 255;
  bands[5] = myFFT.read(91, 209) * 255;
  bands[6] = myFFT.read(210, 400) * 255;
}

void print_msgeq7_bands(uint8_t *bands) {
  Serial.print(timer);
  Serial.print(" ");
  for (int i=0; i<7; i++) {
    Serial.print(bands[i]);
    Serial.print(" ");
  }
  Serial.println();
}

void animate_stefan_petrick(uint8_t *bands) {

  for (int strip = 0; strip < NUM_STRIPS; strip++) {
    animate_strip(strip);
  }
  
  FastLED.show();
  fade_down(4);
}

void animate_strip(int strip) {
  CRGB* current_strip = &leds[NUM_LEDS_PER_STRIP * strip];

  current_strip[START_LED] = CRGB(bands[6], bands[5] / 8, bands[1] / 2);
  current_strip[START_LED].fadeToBlackBy(bands[3] / 12);
  for (int i = START_LED + SIDE_LENGTH; i > START_LED; i--) {
    current_strip[i] = current_strip[i - 1];
  }
  
  for (int i = START_LED - SIDE_LENGTH; i < START_LED; i++) {
    current_strip[i] = current_strip[i + 1];
  }
}

void fade_down(uint8_t value) {
  for (int i = 0; i < NUM_LEDS_PER_STRIP * NUM_STRIPS; i++) {
    leds[i].fadeToBlackBy(value);
  }
}

void print_16_levels() {
  float n;
  int i;
  
  if (myFFT.available()) {
    level[0] =  myFFT.read(0);
    level[1] =  myFFT.read(1);
    level[2] =  myFFT.read(2, 3);
    level[3] =  myFFT.read(4, 6);
    level[4] =  myFFT.read(7, 10);
    level[5] =  myFFT.read(11, 15);
    level[6] =  myFFT.read(16, 22);
    level[7] =  myFFT.read(23, 32);
    level[8] =  myFFT.read(33, 46);
    level[9] =  myFFT.read(47, 66);
    level[10] = myFFT.read(67, 93);
    level[11] = myFFT.read(94, 131);
    level[12] = myFFT.read(132, 184);
    level[13] = myFFT.read(185, 257);
    level[14] = myFFT.read(258, 359);
    level[15] = myFFT.read(360, 511);

    Serial.print(timer);
    Serial.print(" ");
    for (i = 0; i < 16; i++) {
      n = level[i];
//      if (n >= 0.01) {
        Serial.print(n);
        Serial.print(" ");
//      } else {
//        Serial.print("  -  "); // don't print "0.00"
//      }
    }
    Serial.println();
  }
}

void print_40_bins() {
  float n;
  int i;
  
  if (myFFT.available()) {
    Serial.print("FFT: ");
    for (i=0; i<40; i++) {
      n = myFFT.read(i);
      if (n >= 0.01) {
        Serial.print(n);
        Serial.print(" ");
      } else {
        Serial.print("  -  "); // don't print "0.00"
      }
    }
    Serial.println(); 
  }
}

