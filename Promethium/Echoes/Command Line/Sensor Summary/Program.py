# Sample: summarize measurements with libPromethium statistics and integer math.
import statistics
import math

readings = [20, 24, 22]
print("Median low: {0}".format(statistics.median_low(readings)))
print("Pair comparisons: {0}".format(math.comb(len(readings), 2)))
print("Grid width: {0}".format(math.isqrt(144)))
print("Shared sampling interval: {0}".format(math.gcd(18, 24)))
