# Sample: count words with Python modules, a function, and iteration over results.
from collections import Counter
import re


def count_words(text: str) -> Counter[str]:
    return Counter[str](re.split(" ", text))


counts: Counter[str] = count_words("sun sand sea sun sea sun")
for entry in counts.most_common():
    print("{0}: {1}".format(entry[0], entry[1]))
