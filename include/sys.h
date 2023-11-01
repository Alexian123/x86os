#ifndef SYSIO_H
#define SYSIO_H

    #include <libdef.h>

    // write 'val' to 'port'
    extern void outb(u16 port, u8 val);
    extern u8 inb(u16 port);

    // IDT & ISR's
    extern void idt_install();
    extern void idt_set_gate(u8 num, u32 base, u16 sel, u8 flags);
    extern void isrs_install();

    struct regs {
        unsigned int gs, fs, es, ds;
        unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;
        unsigned int int_no, err_code;
        unsigned int eip, cs, eflags, useresp, ss;
    };

#endif