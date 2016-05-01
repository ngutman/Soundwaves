

HUMAN_FREQUENCIES = [0,  50, 100, 200, 500, 1000, 2000, 5000, 10000, 15000, 20000];
HUMAN_CORRECTION =  [-4, -4,  -4,  -2,   2,    2,    4,    8,    -4,     0,    -4];


def calc_multipliers(num_bins, freq_per_bin):
    multipliers = []
    for i in xrange(num_bins):
        freq = int(i * freq_per_bin)
        multipliers.append(get_human_multiplier(freq))
    return multipliers


def get_human_multiplier(frequency, freqs=HUMAN_FREQUENCIES, correction=HUMAN_CORRECTION):
    for i in range(len(freqs)-1):
        if frequency >= freqs[i] and frequency < freqs[i+1]:
            x1 = float(freqs[i])
            x2 = float(freqs[i+1])
            y1 = float(correction[i])
            y2 = float(correction[i+1])
            break
    decibels = ((x2-frequency)*y1 + (frequency-x1)*y2)/(x2-x1)
    return 10.0**(decibels/10.0)


if __name__ == "__main__":
    multipliers = calc_multipliers(num_bins=140, freq_per_bin=43.066)
    float_multipliers = ", ".join(["%.2f" % x for x in multipliers])
    s = "// GENERATED FROM human_adjuster.py\n"
    s += "float HUMAN_MULTIPLIERS[%s] = { %s };" % (len(multipliers), float_multipliers)
    print s