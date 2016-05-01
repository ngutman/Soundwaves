
float smoothFreqValues[NUM_BINS];

void soundFiltersSetup() {
  memset(smoothFreqValues, 0, sizeof(smoothFreqValues));
}

void processSound(float soundArray[]) {
  rollingSmooth(soundArray, 0.8);
}


void rollingSmooth(float soundArray[], float smoothFactor) {
  float antiSmooth = 1 - smoothFactor;
  for (int i = 0; i < NUM_BINS; i++) {
    soundArray[i] = smoothFreqValues[i] * smoothFactor + soundArray[i] * antiSmooth;
    smoothFreqValues[i] = soundArray[i];
  }
}

