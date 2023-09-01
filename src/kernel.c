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

void main() {
    *(short*)0xB8000 = 0x3F00 | 'C';
    move_cursor(0, 1);
    *(short*)0xB8002 = 0x3F00 | 'C';
}
