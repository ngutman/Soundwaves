#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

#define NUM_BINS 140

const int myInput = AUDIO_INPUT_LINEIN;
AudioInputI2S          audioInput;
AudioAnalyzeFFT1024    myFFT;
AudioConnection patchCord1(audioInput, 0, myFFT, 0);
AudioControlSGTL5000 audioShield;

float deltas[NUM_BINS];
float soundArray[NUM_BINS];

void setup() {
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
}

void loop() {
  int i;

  if (myFFT.available()) {
    for (i = 0; i < NUM_BINS; i++) {
      soundArray[i] = myFFT.read(i);
    }
    processSound(soundArray, deltas);

//    printArrayToSerial(soundArray);
    printArrayToSerial(deltas);
  }
}

void printArrayToSerial(float soundArray[]) {
  for (int i = 0; i < NUM_BINS; i++) {
    Serial.print(soundArray[i]);
    Serial.print(" ");
  }
  Serial.println();
}
