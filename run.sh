#!/bin/bash
# Build & run the project

# tools
ASM=/usr/bin/nasm
GCC_PATH=/usr/local/i386elfgcc/bin
CC=$GCC_PATH/i386-elf-gcc
CFLAGS='-Iinclude -ffreestanding -m32 -g -c'
LD=$GCC_PATH/i386-elf-ld

# dirs
SRC_DIR=src
INCLUDE_DIR=include
BIN_DIR=bin
OBJ_DIR=obj

# final binary
OS_BIN=$BIN_DIR/os.bin

# clean build
rm -rf $BIN_DIR
rm -rf $OBJ_DIR
mkdir -p $BIN_DIR
mkdir -p $OBJ_DIR

# complie binaries
$ASM -i $INCLUDE_DIR $SRC_DIR/boot.asm -f bin -o $BIN_DIR/boot.bin
$ASM $SRC_DIR/zeroes.asm -f bin -o $BIN_DIR/zeroes.bin

# compile objects
$ASM $SRC_DIR/kernel_entry.asm -f elf -o $OBJ_DIR/kernel_entry.o
$ASM $SRC_DIR/sysio.asm -f elf -o $OBJ_DIR/sysio.o
$CC $CFLAGS $SRC_DIR/kernel.c -o $OBJ_DIR/kernel.o
$CC $CFLAGS $SRC_DIR/str.c -o $OBJ_DIR/str.o
$CC $CFLAGS $SRC_DIR/textio.c -o $OBJ_DIR/textio.o
$CC $CFLAGS $SRC_DIR/idt.c -o $OBJ_DIR/idt.o
$CC $CFLAGS $SRC_DIR/isrs.c -o $OBJ_DIR/isrs.o

# link objects
$LD -o $BIN_DIR/kernel.bin -Ttext 0x1000 \
$OBJ_DIR/kernel_entry.o $OBJ_DIR/kernel.o  $OBJ_DIR/sysio.o $OBJ_DIR/textio.o \
$OBJ_DIR/idt.o $OBJ_DIR/isrs.o $OBJ_DIR/str.o --oformat binary

# merge binaries
cat $BIN_DIR/boot.bin $BIN_DIR/kernel.bin $BIN_DIR/zeroes.bin  > $OS_BIN

# run vm
qemu-system-x86_64 -drive format=raw,file=$OS_BIN,index=0,if=floppy, -m 128M