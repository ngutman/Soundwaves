#define USE_OCTOWS2811
#include<OctoWS2811.h>
#include<FastLED.h>
#include <Audio.h>
#include <Wire.h>

#define NUM_LEDS_PER_STRIP 210
#define NUM_STRIPS 7

CRGB leds[NUM_STRIPS * NUM_LEDS_PER_STRIP];

const int myInput = AUDIO_INPUT_LINEIN;

// Pin layouts on the teensy 3:
// OctoWS2811: 2,14,7,8,6,20,21,5

AudioInputI2S          audioInput;         // audio shield: mic or line-in
AudioAnalyzeFFT1024    myFFT;

AudioConnection patchCord1(audioInput, 0, myFFT, 0);

AudioControlSGTL5000 audioShield;

void setup() {
  LEDS.addLeds<OCTOWS2811>(leds, NUM_LEDS_PER_STRIP);

  AudioMemory(12);

  audioShield.enable();
  audioShield.inputSelect(myInput);
  audioShield.volume(0.5);

  audioShield.lineInLevel(15);
}

int frames = 0;
int fftFrames = 0;

void print_40_bins();

void loop() {
  print_40_bins();
  
  fill_rainbow(leds, NUM_STRIPS * NUM_LEDS_PER_STRIP, 0);
  FastLED.show();

  frames++;
  EVERY_N_MILLIS(1000) {
    Serial.print("FastLED.getFPS: ");
    Serial.print(FastLED.getFPS());
    Serial.print("   manual FPS: ");
    Serial.println(frames);
    frames = 0;

    Serial.print("FFT frames: ");
    Serial.println(fftFrames);
    fftFrames = 0;
  }
}

void print_40_bins() {
  float n;
  int i;
  
  if (myFFT.available()) {
    fftFrames++;
//    Serial.print("FFT: ");
    for (i=0; i<40; i++) {
      n = myFFT.read(i);
      if (n >= 0.01) {
//        Serial.print(n);
//        Serial.print(" ");
      } else {
//        Serial.print("  -  "); // don't print "0.00"
      }
    }
//    Serial.println(); 
  }
}
