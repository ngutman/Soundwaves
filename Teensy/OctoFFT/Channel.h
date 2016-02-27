#ifndef _CHANNEL_H_
#define _CHANNEL_H_

#include <Arduino.h>

#define SAMPLES 60

class Channel {
  public: 
    Channel();

    uint8_t minLvlAvg;
    uint8_t maxLvlAvg;
    uint8_t samples[SAMPLES];
    int volCount;

    uint8_t updateAndRead(uint8_t level);
};

#endif _CHANNEL_H_
