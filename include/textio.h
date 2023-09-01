#ifndef TEXTIO_H
#define TEXTIO_H

    #include <libdef.h>
    #include <types.h>
    
    #define VGA_WIDTH 80

    extern void disable_cursor();
    extern void move_cursor(i32 x, i32 y);

    extern void putc(i16 c);        // print character
    extern void puts(const char *str);   // print string

#endif