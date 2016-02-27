#include "Channel.h"

Channel::Channel() {
  
}

uint8_t Channel::updateAndRead(uint8_t level) {
      uint8_t minLvl;
      uint8_t maxLvl;
      uint8_t out;

      out = (256 * (level - minLvlAvg) / (maxLvlAvg - minLvlAvg));

      samples[volCount] = level;

      if (++volCount >= SAMPLES) volCount = 0;

      minLvl = maxLvl = samples[0];

      for (int i = 0; i < SAMPLES; i++) {
        if (samples[i] < minLvl) minLvl = samples[i];
        if (samples[i] > maxLvl) maxLvl = samples[i];
      }

      minLvlAvg = (minLvlAvg * 63 + minLvl) >> 6;
      maxLvlAvg = (maxLvlAvg * 63 + maxLvl) >> 6;

      return out;
    }
