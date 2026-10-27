# Sample: stream values from a Python generator into a normal for loop.
def even_numbers(limit: int):
    for number in range(limit):
        if number % 2 == 0:
            yield number


for number in even_numbers(8):
    print("even: {0}".format(number))
