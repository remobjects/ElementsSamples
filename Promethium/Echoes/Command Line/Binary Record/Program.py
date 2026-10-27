# Sample: encode a network-order integer with libPromethium binary helpers.
import struct
import binascii

payload: bytes = struct.pack_uint16_be(513)
print("Hex: {0}".format(binascii.hexlify(payload)))
print("Value: {0}".format(struct.unpack_uint16_be(payload)))
print("Bytes: {0}".format(len(payload)))
