
float smoothFreqValues[NUM_BINS];
float averages[NUM_BINS];

void soundFiltersSetup() {
  memset(smoothFreqValues, 0, sizeof(smoothFreqValues));
  memset(averages, 0, sizeof(averages));
}

void processSound(float soundArray[], float deltas[]) {
  rollingSmooth(soundArray, 0.8);
  adjustHumanEar(soundArray);
  rollingScaleToMax(soundArray);
  exaggerate(soundArray, 2);

  calcDeltasAndAverages(deltas, soundArray, 0.8);
}

void calcDeltasAndAverages(float deltas[], float soundArray[], float deltaFactor) {
  float averageFactor = 0.9;
  
  for (int i = 0; i < NUM_BINS; i++) {
    averages[i] = averages[i] * averageFactor + soundArray[i] * (1 - averageFactor);
    deltas[i] = max(soundArray[i] - averages[i]*deltaFactor, 0);
  }
}

void rollingSmooth(float soundArray[], float smoothFactor) {
  float antiSmooth = 1 - smoothFactor;
  for (int i = 0; i < NUM_BINS; i++) {
    soundArray[i] = smoothFreqValues[i] * smoothFactor + soundArray[i] * antiSmooth;
    smoothFreqValues[i] = soundArray[i];
  }
}

// GENERATED FROM human_adjuster.py
float HUMAN_MULTIPLIERS[140] = { 0.40, 0.40, 0.40, 0.45, 0.55, 0.72, 1.08, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.58, 1.61, 1.64, 1.67, 1.71, 1.74, 1.78, 1.81, 1.85, 1.89, 1.92, 1.96, 2.00, 2.04, 2.08, 2.12, 2.17, 2.21, 2.25, 2.30, 2.35, 2.39, 2.44, 2.49, 2.53, 2.56, 2.60, 2.63, 2.67, 2.70, 2.74, 2.78, 2.81, 2.85, 2.89, 2.93, 2.96, 3.00, 3.05, 3.09, 3.13, 3.17, 3.21, 3.25, 3.30, 3.34, 3.38, 3.43, 3.47, 3.52, 3.57, 3.62, 3.66, 3.71, 3.76, 3.81, 3.86, 3.91, 3.97, 4.02, 4.07, 4.13, 4.18, 4.24, 4.29, 4.35, 4.41, 4.47, 4.53, 4.59, 4.65, 4.71, 4.77, 4.84, 4.90, 4.97, 5.03, 5.10, 5.17, 5.24, 5.30, 5.38, 5.45, 5.52, 5.59, 5.67, 5.74, 5.82, 5.90, 5.98, 6.06, 6.14, 6.22, 6.30, 6.18, 6.03, 5.89, 5.75, 5.62, 5.48, 5.35, 5.23, 5.11, 4.99, 4.87, 4.75, 4.64, 4.53, 4.43, 4.32, 4.22, 4.12, 4.03, 3.93, 3.84, 3.75, 3.66 };

void adjustHumanEar(float soundArray[]) {
  for (int i = 0; i < NUM_BINS; i++) {
    soundArray[i] *= HUMAN_MULTIPLIERS[i];
  }
}

void rollingScaleToMax(float soundArray[]) {
  static float avgPeak = 0.0;
  static float falloff = 0.9;
  
  float peak = maxArray(soundArray, NUM_BINS);
  if (peak > avgPeak) {
    avgPeak = peak;
  } else {
    avgPeak *= falloff;
    avgPeak += peak * (1 - falloff);
  }
  if (avgPeak < 0.01) {
    return;
  }
  for (int i = 0; i < NUM_BINS; i++) {
    soundArray[i] /= avgPeak;
  }
}

void exaggerate(float soundArray[], float exponent) {
  for (int i = 0; i < NUM_BINS; i++) {
    soundArray[i] = pow(soundArray[i], exponent);
  }
}

float maxArray(float arr[], int arrayLength) {
  float maxValue = arr[0];
  for (int i = 0; i < arrayLength; i++) {
    if (arr[i] > maxValue) {
      maxValue = arr[i];
    }
  }
  return maxValue;
}

void createBands(float f[], float bands[]) {
  bands[0] = processBand(f, 0, 2);
  bands[1] = processBand(f, 2, 4);
  bands[2] = processBand(f, 7, 9);
  bands[3] = processBand(f, 17, 17);
  bands[4] = processBand(f, 35, 24);
  bands[5] = processBand(f, 60, 80);
}

float processBand(float f[], int startIndex, int numValues) {
  return maxArray(&f[startIndex], numValues);
}

