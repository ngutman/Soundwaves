#define NUM_STRIPS 8
#define NUM_LEDS_PER_STRIP 75
#define MOVE_PIXEL_EVERY_X_MS 5

#define USE_OCTOWS2811
#include <OctoWS2811.h>
#include <FastLED.h>
#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>
#include "Globals.h"
#include "SoundFilters.h"
#include "Animations.h"

const int myInput = AUDIO_INPUT_LINEIN;
AudioInputI2S          audioInput;
AudioAnalyzeFFT1024    myFFT;
AudioConnection patchCord1(audioInput, 0, myFFT, 0);
AudioControlSGTL5000 audioShield;

float deltas[NUM_BINS];
float soundArray[NUM_BINS];
float bands[6];

// Pin layouts on the teensy 3:
// OctoWS2811: 2,14,7,8,6,20,21,5

CRGB leds[NUM_STRIPS * NUM_LEDS_PER_STRIP];


void setup() {
  LEDS.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);
  
  // Audio connections require memory to work.  For more
  // detailed information, see the MemoryAndCpuUsage example
  AudioMemory(12);

  // Enable the audio shield and set the output volume.
  audioShield.enable();
  audioShield.inputSelect(myInput);
  audioShield.lineInLevel(15);

  // Configure the window algorithm to use
  myFFT.windowFunction(AudioWindowHanning1024);

  soundFiltersSetup();

  memset(deltas, 0, sizeof(deltas));

  FastLED.setBrightness(200);
}

void printArrayToSerial(float soundArray[], int arrayLength);
void printLedsToSerial(CRGB leds[]);
void setBrightnessFromPot();

void loop() {
  setBrightnessFromPot();
  
  int i;

  if (myFFT.available()) {
    for (i = 0; i < NUM_BINS; i++) {
      soundArray[i] = myFFT.read(i);
    }
    processSound(soundArray, deltas);
    createBands(deltas, bands);
    bandsAnimation(bands, leds);

//    printArrayToSerial(soundArray, NUM_BINS);
//    printArrayToSerial(deltas, NUM_BINS);
    printArrayToSerial(bands, 6);
//    printLedsToSerial(leds);
  }

  EVERY_N_MILLIS(1000) {
//    Serial.print("FastLED.getFPS: ");
//    Serial.println(FastLED.getFPS());
  }

  FastLED.show();
}

void setBrightnessFromPot() {
  static float potValue = 0;
  potValue = 0.99 * potValue + 0.01 * analogRead(A8);
  int brightnessVal = potValue*255/1023;
//  Serial.println(brightnessVal);
  FastLED.setBrightness(brightnessVal);
}

void printLedsToSerial(CRGB leds[]) {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 1; j++) {
      CRGB pixel = leds[i*NUM_LEDS_PER_STRIP + j];
      Serial.print(pixel.r*256*256 + pixel.g*256 + pixel.b);
      Serial.print(" ");
    }
  }
  Serial.println();
}

void printArrayToSerial(float soundArray[], int arrayLength) {
  for (int i = 0; i < arrayLength; i++) {
    Serial.print(soundArray[i]);
    Serial.print(" ");
  }
  Serial.println();
}
