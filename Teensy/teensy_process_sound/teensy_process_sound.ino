#define NUM_STRIPS 8
#define NUM_LEDS_PER_STRIP 210

#define USE_OCTOWS2811
#include <OctoWS2811.h>
#include <FastLED.h>
#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>
#include <Bounce.h>
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

Bounce controlButton = Bounce(CONTROL_PIN, 10);  // 10 ms debounce

void printArrayToSerial(float soundArray[], int arrayLength);
void printLedsToSerial(CRGB leds[]);
void setBrightnessFromPot();
void setSpeedFromKY040();
void setupKY040();

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

  setupKY040();
}

void loop() {
  setBrightnessFromPot();
  setSpeedFromKY040();
  
  int i;

  if (myFFT.available()) {
    for (i = 0; i < NUM_BINS; i++) {
      soundArray[i] = myFFT.read(i);
    }
    processSound(soundArray, deltas);
    createBands(deltas, bands);

//    printArrayToSerial(soundArray, NUM_BINS);
//    printArrayToSerial(deltas, NUM_BINS);
    printArrayToSerial(bands, 6);
//    printLedsToSerial(leds);
  }

  EVERY_N_MILLIS(1000) {
//    Serial.print("FastLED.getFPS: ");
//    Serial.println(FastLED.getFPS());
  }

  bandsAnimation(bands, leds);
  FastLED.show();
}

void setupKY040() {
  pinMode(KY040_CLK, INPUT);
  pinMode(KY040_DT, INPUT);
  
  pinMode(CONTROL_PIN, INPUT_PULLUP);
}

void setSpeedFromKY040() {
  static uint8_t pinCLKlast = digitalRead(KY040_CLK);
  uint8_t currentVal;
  EVERY_N_MILLIS(5) {
    currentVal = digitalRead(KY040_CLK);

    if (currentVal != pinCLKlast) {
      if (digitalRead(KY040_DT) == currentVal) {
        animationSpeed += 1;
      } else {
        animationSpeed -= 1;
      }
    }
  
    if (animationSpeed > MAX_SPEED_OFFSET) {
      animationSpeed = MAX_SPEED_OFFSET;
    } else if (animationSpeed < MIN_SPEED_OFFSET) {
      animationSpeed = MIN_SPEED_OFFSET;
    }
    pinCLKlast = currentVal;
    Serial.println(animationSpeed);
  }
}

void setBrightnessFromPot() {
  static float potValue = 0;
  static bool controlConnected = false;
  
  potValue = 0.99 * potValue + 0.01 * analogRead(BRIGHTNESS_PIN);
  int brightnessVal = potValue*255/1023;
  if (brightnessVal <= 5) {
    brightnessVal = 0;
  }

  if (controlButton.update()) {
    if (controlButton.fallingEdge()) {
      controlConnected = !controlConnected;
    }
  }

  if (!controlConnected) {
    brightnessVal = 255;
  }
  
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
