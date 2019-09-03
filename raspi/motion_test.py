
import motion
import random

print("test")

data = [[],[],[]]
for i in range(10):
    data[0].append(random.random())
    data[1].append(random.random())
    data[2].append(random.random())

print("==data==")
print(data)
print("strength=%.2f" % (motion.strength(data)))
