import sys
import logging as log
import argparse

VECTOR_SIZE 	= 4
VECTORS_COUNT 	= 7
UINT32_MASK 	= 0xFFFFFFFF

def signFirmware(file):
    try:
        rawData = bytearray(file.read(VECTORS_COUNT * VECTOR_SIZE))
        checksum = vector = 0
        for i in range(0, VECTORS_COUNT * VECTOR_SIZE):
            vector = vector >> 8 & 0x00FFFFFF
            vector |= rawData[i] << 24
            if ((i + 1) % VECTOR_SIZE == 0):
                log.debug("vector = 0x%08X" %vector)
                checksum = checksum - vector & 0xFFFFFFFF
        log.debug("checksum = %X" %checksum)
        rawData = bytearray(VECTOR_SIZE)
        for bytePos in range(0, VECTOR_SIZE):
            rawData[bytePos] = (checksum >> (bytePos * 8)) & 0xFF
        file.seek(VECTORS_COUNT * VECTOR_SIZE)
        file.write(rawData)
        log.info("Firmware Signed Successfully")
    except Exception as e:
        log.error(str(e))

parser = argparse.ArgumentParser()
parser.add_argument("file", type=argparse.FileType('r+b'), help="Path to target binary file")
parser.add_argument("-v", "--verbose", action="store_true")
args = parser.parse_args()
if args.verbose:
    log.basicConfig(format="%(levelname)s: %(message)s", level=log.DEBUG)
else:
    log.basicConfig(format="%(levelname)s: %(message)s")
log.info("Signer started")
signFirmware(args.file)
args.file.close()
