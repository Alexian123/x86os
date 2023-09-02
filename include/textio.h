#ifndef TEXTIO_H
#define TEXTIO_H

    #include <libdef.h>
    
    #define VGA_WIDTH 80
    #define VGA_HEIGHT 25

    enum color
    {
        BLACK = 0x0, BLUE, GREEN, AQUA,
        RED, MAGENTA, ORANGE, LIGHT_GREY,
        DARK_GREY, PURPLE, LIGHT_GREEN, CYAN,
        SALMON_PINK, PINK, YELLOW, WHITE = 0xF
    };

    extern void disable_cursor();
    extern void move_cursor(u8 x, u8 y);
    extern u8 get_cursor_x();
    extern u8 get_cursor_y();

    extern void set_bg_color(enum color c);
    extern void set_text_color(enum color c);

    // print functions
    extern void print_chr(u8 c);
    extern void print_str(const char *str);
    extern void print_int(i32 i);

#endif