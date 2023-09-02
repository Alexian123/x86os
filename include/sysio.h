#ifndef SYSIO_H
#define SYSIO_H

    #include <libdef.h>

    // write 'val' to 'port'
    extern void outb(u16 port, u8 val);
    extern u8 inb(u16 port);

#endif