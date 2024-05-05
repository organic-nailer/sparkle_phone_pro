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
        colors = np.zeros((68,3), dtype=np.uint8)
        r = 3 if phase % 3 == 0 else 1
        g = 3 if phase % 4 == 0 else 1
        b = 3 if phase % 5 == 0 else 1
        colors[:10,0] = r
        colors[10:20,1] = g
        colors[20:30,2] = b

        colors = np.roll(colors, i, axis=0)

        buffer = np.zeros(51, dtype=np.uint8)
        for j in range(17):
            buffer[j*3] = (colors[j*4,0] << 0) + (colors[j*4+1,0] << 2) + (colors[j*4+2,0] << 4) + (colors[j*4+3,0] << 6)
            buffer[j*3+1] = (colors[j*4,1] << 0) + (colors[j*4+1,1] << 2) + (colors[j*4+2,1] << 4) + (colors[j*4+3,1] << 6)
            buffer[j*3+2] = (colors[j*4,2] << 0) + (colors[j*4+1,2] << 2) + (colors[j*4+2,2] << 4) + (colors[j*4+3,2] << 6)
        # random_values = np.hstack((random_values, np.array([255], dtype=np.uint8)))
        ser.write(buffer.tobytes())
        time.sleep(0.001)
        # value = ser.readline()
        # if len(value) > 0:
        #     print(struct.unpack("!B", value)[0])
        i += 1
        if i > 66:
            print("Time elapsed: ", time.time() - start)
            start = time.time()
            i = 0
            phase += 1
except KeyboardInterrupt:
    ser.close()
    print("Serial port closed")
