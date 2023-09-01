#!/bin/bash
# Build & run the project

# tools
ASM=/usr/bin/nasm
GCC_PATH=/usr/local/i386elfgcc/bin
CC=$GCC_PATH/i386-elf-gcc
LD=$GCC_PATH/i386-elf-ld

# dirs
SRC_DIR=src
BIN_DIR=bin

# final binary
OS_BIN=$BIN_DIR/os.bin

# clean build
rm -rf $BIN_DIR
mkdir -p $BIN_DIR

# complie binaries
$ASM -i src $SRC_DIR/boot.asm -f bin -o $BIN_DIR/boot.bin
$ASM $SRC_DIR/zeroes.asm -f bin -o $BIN_DIR/zeroes.bin

# compile objects
$ASM $SRC_DIR/kernel_entry.asm -f elf -o $BIN_DIR/kernel_entry.o
$ASM $SRC_DIR/sysio.asm -f elf -o $BIN_DIR/sysio.o
$CC -ffreestanding -m32 -g -c $SRC_DIR/kernel.c -o $BIN_DIR/kernel.o

# link objects
$LD -o $BIN_DIR/kernel.bin -Ttext 0x1000 \
$BIN_DIR/kernel_entry.o $BIN_DIR/kernel.o  $BIN_DIR/sysio.o \
--oformat binary

# merge binaries
cat $BIN_DIR/boot.bin $BIN_DIR/kernel.bin $BIN_DIR/zeroes.bin  > $OS_BIN

# run vm
qemu-system-x86_64 -drive format=raw,file=$OS_BIN,index=0,if=floppy, -m 128M