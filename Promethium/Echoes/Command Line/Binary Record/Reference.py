# CPython oracle for the equivalent struct and binascii operations.
import struct
import binascii
payload = struct.pack(">H", 513)
print("Hex: {0}".format(binascii.hexlify(payload).decode("ascii")))
print("Value: {0}".format(struct.unpack(">H", payload)[0]))
print("Bytes: {0}".format(len(payload)))
