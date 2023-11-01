#include <types.h>
#include <str.h>

#define MAX_IDT_ENTRIES 256

struct idt_entry
{
    u16 base_lo;
    u16 sel;
    u8 zero;
    u8 flags;
    u16 base_hi;
} __attribute__((packed));

struct idt_ptr
{
    u16 limit;
    u32 base;

} __attribute__((packed));

struct idt_entry idt[MAX_IDT_ENTRIES];
struct idt_ptr idtp;

extern void idt_load();

void idt_set_gate(u8 num, u32 base, u16 sel, u8 flags) {
    idt[num].base_lo = base & 0xFFFF;
    idt[num].sel = sel;
    idt[num].zero = 0;
    idt[num].flags = flags;
    idt[num].base_hi = (base >> 16) & 0xFFF;
}

void idt_install() {
    idtp.limit = (sizeof (struct idt_entry) * MAX_IDT_ENTRIES) - 1;
    idtp.base = (u32) idt;

    // clear the whole IDT
    memset(idt, 0, sizeof (struct idt_entry) * MAX_IDT_ENTRIES);

    // add new ISR's with idt_set_gate

    // load the new IDT
    idt_load();
}