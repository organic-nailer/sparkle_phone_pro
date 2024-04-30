import serial
import time
import struct
import numpy as np

def int_to_bin(value_list: list[int]):
    out = b""
    for value in value_list:
        out += struct.pack("!B", value)
    return out

ser = serial.Serial("COM4", 56700, timeout=0.01)

i = 0
phase = 0
try:
    print("Sending message to Arduino")
    start = time.time()
    while True:
        random_values = np.zeros(64, dtype=np.uint8)
        r = 3 if phase % 3 == 0 else 1
        g = 3 if phase % 4 == 0 else 1
        b = 3 if phase % 5 == 0 else 1
        random_values[:10] = (r << 4) + (g << 2) + b
        random_values = np.roll(random_values, i)
        random_values = np.hstack((random_values, np.array([255], dtype=np.uint8)))
        ser.write(random_values[:50].tobytes())
        time.sleep(0.003)
        ser.write(random_values[50:].tobytes())
        time.sleep(0.003)
        # value = ser.readline()
        # if len(value) > 0:
        #     print(struct.unpack("!B", value)[0])
        i += 1
        if i > 64:
            print("Time elapsed: ", time.time() - start)
            start = time.time()
            i = 0
            phase += 1
except KeyboardInterrupt:
    ser.close()
    print("Serial port closed")
