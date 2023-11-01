#include <textio.h>
#include <sys.h>

#define VIDEO_MEMORY_LOC 0xB8000

static u16 *VGABuff = (u16*) VIDEO_MEMORY_LOC;
static enum color bgColor = BLACK;
static enum color textColor = WHITE;

static void _move_cursor(u16 pos);
static u16 _get_cursor_position();
static void _print_chr_at(u8 c, u16 pos);     // print character at pos with no cursor update

void disable_cursor() {
    outb(0x3D4, 0x0A);
    outb(0x3D5, 0x20);
}

void move_cursor(u8 x, u8 y) {
    u16 pos = MIN(y, VGA_HEIGHT - 1) * VGA_WIDTH + MIN(x, VGA_WIDTH - 1);
    _move_cursor(pos);
}

void _move_cursor(u16 pos) {
    pos = MIN(pos, VGA_WIDTH*VGA_HEIGHT - 1);
    outb(0x3D4, 0x0F);
    outb(0x3D5, (u8) (pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (u8) ((pos >> 8) & 0xFF));
}

u16 _get_cursor_position() {
    u16 pos = 0;
    outb(0x3D4, 0x0F);
    pos |= inb(0x3D5);
    outb(0x3D4, 0x0E);
    pos |= ((u16)inb(0x3D5)) << 8;
    return pos;
}

u8 get_cursor_x() {
    return _get_cursor_position() % VGA_WIDTH;
}

u8 get_cursor_y() {
    return _get_cursor_position() / VGA_WIDTH;
}

void set_bg_color(enum color c) {
    bgColor = c;
}

void set_text_color(enum color c) {
    textColor = c;
}

void print_chr(u8 c) {
    u16 pos = _get_cursor_position();
    _print_chr_at(c, pos);
    _move_cursor(pos + 1);
}

void _print_chr_at(u8 c, u16 pos) {
    VGABuff[pos] = (bgColor << 12) | (textColor << 8) | c;
}

void print_str(const char *str) {
    u16 pos = _get_cursor_position();
    while (str && *str && pos < VGA_WIDTH*VGA_HEIGHT) {
        _print_chr_at(*str, pos);
        ++str;
        ++pos;
    }
    _move_cursor(pos);
}

void print_int(i32 i) {
    if (i < 0) {
        print_chr('-');
        i *= (-1);
    }
    if (i <= 9) {
        print_chr(i + '0');
        return;
    }
    print_int(i/10);
    print_chr(i%10 + '0');
}