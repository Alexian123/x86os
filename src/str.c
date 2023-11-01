#include <str.h>

void *memcpy(void *dest, const void *src, size_t n_bytes) {
    u8 *dp = (u8*) dest;
    const u8 *sp = (const u8*) src;
    for (; n_bytes != 0; --n_bytes) {
        *dp++ = *sp++;
    }
    return dest;
}

void *memset(void *dest, u8 val, size_t n_bytes) {
    u8 *dp = (u8*) dest;
    for (; n_bytes != 0; --n_bytes) {
        *dp++ = val;
    }
    return dest;
}

void *memsetw(void *dest, u16 val, size_t n_bytes) {
    u16 *dp = (u16*) dest;
    for (; n_bytes != 0; --n_bytes) {
        *dp++ = val;
    }
    return dest;
}

void *memsetdw(void *dest, u32 val, size_t n_bytes) {
    u32 *dp = (u32*) dest;
    for (; n_bytes != 0; --n_bytes) {
        *dp++ = val;
    }
    return dest;
}

char *strcpy(char *dest, const char *src, size_t n) {
    for (; n != 0; --n) {
        *dest++ = *src++;
    }
    return dest;
}

size_t strlen(const char *str) {
    size_t ret_val = 0;
    for (; *str != 0; ++str) {
        ++ret_val;
    }
    return ret_val;
}