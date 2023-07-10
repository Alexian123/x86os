boot.bin: boot.asm
	nasm -f bin $^ -o $@

run: boot.bin
	qemu-system-x86_64 $^

clean:
	rm -f boot.bin

.PHONY: run clean
