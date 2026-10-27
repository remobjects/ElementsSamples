# Sample: combine typed functions from two files in one Elements namespace.
@namespace("trip_budget")


costs = [25, 40, 10]
subtotal = total(costs)
print("Subtotal: {0}".format(subtotal))
print("With tax: {0}".format(with_tax(subtotal, 8)))
