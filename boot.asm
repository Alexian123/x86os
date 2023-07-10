    mov ah, 0xE     ; teletype mode
    mov al, 'a'     ; char to print

LOOP:
    test al, 0x1    ; al % 2 == 0 ?
    jz EVEN
    sub al, 'a'-'A'     ; convert to uppercase
    jmp PRINT

EVEN:
    add al, 'a'-'A'     ; convert to lowecase

PRINT:
    int 0x10    ; BIOS interrupt
    inc al
    cmp al, 'z' ; loop condition
    jbe LOOP

    jmp $   ; loop forever

    times 510-($-$$) db 0   ; padding zeros
    db 0x55, 0xAA           ; mark end of boot sector
