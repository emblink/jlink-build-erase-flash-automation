clean:				## tidy build directory
	@echo Tyding things up...
	rm -f *elf *map *bin

load: HeraclesApplicationFirmware.bin
	JLink.exe -autoconnect 1 -device LPC54605J512 -if swd -speed 4000 -CommandFile myCmdFile.jlink

all:
	rm -f *elf *map *bin
	cp /d/__Developex__Work__/heracleskeyboardbootloader/bin/Release/HeraclesKeyboardBootloader* .
	cp /d/__Developex__Work__/heracleskeyboardfirmware/bin/Release/HeraclesApplicationFirmware* .
	python ./signer.py ./HeraclesKeyboardBootloader.bin
	python ./fwHeaderSigner.py ./HeraclesApplicationFirmware.bin 0
	truncate -s 65536 HeraclesKeyboardBootloader.bin
	cat HeraclesApplicationFirmware.bin >> HeraclesKeyboardBootloader.bin
	rm -f HeraclesApplicationFirmware.bin
	@echo Build Success!
	JLink.exe -autoconnect 1 -device LPC54605J512 -if swd -speed 4000 -CommandFile myCmdFile.jlink
	@echo Load Success!