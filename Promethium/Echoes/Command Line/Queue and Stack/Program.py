# Show the same FIFO and LIFO behavior as the Oxygene Queue and Stack sample.
# Python lists provide append/pop operations without custom container classes.
stack: list[str] = ["first", "second", "third"]
queue: list[int] = [10, 20, 30]

print("Stack (last in, first out):")
while len(stack) > 0:
    print(stack.pop())

print("Queue (first in, first out):")
while len(queue) > 0:
    print(queue.pop(0))

# A drained container can be reused.
stack.append("new item")
queue.append(40)
print("Reused stack: {0}".format(stack.pop()))
print("Reused queue: {0}".format(queue.pop(0)))
print("Remaining items: {0}".format(len(stack) + len(queue)))
