#define VGA_WIDTH 80

extern void outb(unsigned short port, unsigned char val);

void disable_cursor() {
    outb(0x03D4, 0x0A);
    outb(0x3D5, 0x20);
}

void move_cursor(int x, int y) {
    unsigned short pos = y * VGA_WIDTH + x;
    outb(0x03D4, 0x0F);
    outb(0x03D5, (unsigned char) (pos & 0xFF));
    outb(0x03D4, 0x0E);
    outb(0x03D5, (unsigned char) ((pos >> 8) & 0xFF));
}

void putc(unsigned char c) {
    static short *screen = 0xB8000;
    *screen = 0x0F00 | c;
    ++screen;
}

void puts(const char *str) {
    static int cursor_x = 0;
    while (str != 0 && *str) {
        putc(*str);
        ++str;
        ++cursor_x;
    }
    move_cursor(cursor_x, 0);
}

void main() {
    puts("Hello, World!");
}
