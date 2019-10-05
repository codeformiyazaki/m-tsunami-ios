

def test_strength():
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

def test_rails():
    import requests, json
    # q = {'quake': {'elapsed': 1.1 , 'p': 2.1, 's': 3.1, 'device_id': 0 }}
    q = {'quake[elapsed]': 1.1 , 'quake[p]': 2.1, 'quake[s]': 3.1, 'quake[device_id]': 0 }
    r = requests.post("http://localhost:5000/quakes.json", data = q)
    print(r)

test_rails()
