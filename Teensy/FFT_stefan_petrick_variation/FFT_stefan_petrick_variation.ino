#define USE_OCTOWS2811
#include <OctoWS2811.h>
#include <FastLED.h>
#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

#define NUM_LEDS_PER_STRIP 60
#define NUM_STRIPS 1
#define START_LED 30
#define SIDE_LENGTH 26


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

float low_bass;
float mid_bass;
float lower_treble;
float low_treble;
float midlow_treble;
float mid_treble;
float midhigh_treble;
float high_treble;

float level[16];
elapsedMillis timer;

void animate_stefan_petrick(uint8_t *bands);
void fade_down(uint8_t value);
void analyze_bins();
void print_bins();
void animate_strip(int strip);

uint8_t bands[7];

void loop() {
  if (myFFT.available()) {
    analyze_bins();
    print_bins();

    EVERY_N_MILLISECONDS(30) {
      animate_stefan_petrick(bands);
    }
  }
}

void analyze_bins() {
  low_bass = myFFT.read(0, 2) * 255;              
  mid_bass = myFFT.read(2, 6) * 255;
  lower_treble = myFFT.read(7, 19) * 255;
  low_treble = myFFT.read(7, 19) * 255;
  midlow_treble = myFFT.read(20, 30) * 255;
  mid_treble = myFFT.read(31, 90) * 255;
  midhigh_treble = myFFT.read(91, 209) * 255;
  high_treble = myFFT.read(210, 400) * 255;
}

void print_bins() {
  Serial.print(mid_bass);
  Serial.print(" \t ");
  Serial.print(midlow_treble);
  Serial.print(" \t ");
  Serial.print(mid_treble);
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
  
  current_strip[START_LED] = CRGB(mid_treble, midlow_treble, mid_bass / 2);
  
  current_strip[START_LED].fadeToBlackBy(lower_treble / 12);
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

