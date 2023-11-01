#ifndef STR_H
#define STR_H

    #include <libdef.h>

    // Copy raw bytes
    extern void *memcpy(void *dest, const void *src, size_t n_bytes);

    // Fill memory with val
    extern void *memset(void *dest, u8 val, size_t n_bytes);    // bytes
    extern void *memsetw(void *dest, u16 val, size_t n_bytes);  // words
    extern void *memsetdw(void *dest, u32 val, size_t n_bytes); // double words

    // Manipulate strings (null-terminated char arrays)
    extern char *strcpy(char *dest, const char *src, size_t n);
    extern size_t strlen(const char *str);  // unsafe !


#endif