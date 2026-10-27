# Sample: count words using a typed dictionary, indexing, and libPromethium regex.
import re


def count_words(text: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for word in re.split(" ", text):
        counts[word] = counts.get(word, 0) + 1
    return counts


counts = count_words("sun sand sea sun sea sun")
for word in ["sun", "sea", "sand"]:
    print("{0}: {1}".format(word, counts[word]))
