#include <textio.h>

#define VIDEO_MEMORY_LOC 0xB8000

static u16 *VGABuff = (u16*) VIDEO_MEMORY_LOC;
static i32 cursorXPos = 0;

extern void outb(u16 port, u8 val); // write 'val' to 'port'

extern void _putc(i16 c);   // print character without moving the cursor

void disable_cursor() {
    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);
}

void move_cursor(i32 x, i32 y) {
    u16 pos = y * VGA_WIDTH + x;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (u8) (pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (u8) ((pos >> 8) & 0xFF));
}

void putc(i16 c) {
    _putc(c);
    move_cursor(++cursorXPos, 0);
}

void _putc(i16 c) {
    *VGABuff = 0x0F00 | c;
    ++VGABuff;
}

void puts(const char *str) {
    while (str && *str) {
        _putc(*str);
        ++str;
        ++cursorXPos;
    }
    move_cursor(cursorXPos, 0);
}