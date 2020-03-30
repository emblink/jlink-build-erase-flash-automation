APPLICATION = HeraclesApplicationFirmware.bin
BOOTLOADER = HeraclesBootloaderFirmware.bin
APPLICATION_PATH = /d/__Developex__Work__/heracleskeyboardfirmware/bin/Release/HeraclesApplicationFirmware
BOOTLOADER_PATH = /d/__Developex__Work__/heracleskeyboardbootloader/bin/Release/HeraclesBootloaderFirmware

all: build load
	@echo Done!

clean:				## tidy build directory
	@echo Tyding things up...
	rm -f *elf *map *bin

load:
	JLink.exe -autoconnect 1 -device LPC54605J512 -if swd -speed 4000 -CommandFile myCmdFile.jlink
	@echo Load Success!

build: clean
	@echo Build Started!
	cp $(APPLICATION_PATH)* .
	cp $(BOOTLOADER_PATH)* .
	python ./signer.py ./$(BOOTLOADER)
	python ./fwHeaderSigner.py ./$(APPLICATION) 0
	truncate -s 65536 $(BOOTLOADER)
	cat $(APPLICATION) >> $(BOOTLOADER)
	rm -f $(APPLICATION)
	@echo Build Success!
	