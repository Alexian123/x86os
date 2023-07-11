    [org 0x7C00]    ; set memory addressing origin

    mov bx, textToPrint1    ; char* to print
    call PRINT_STR

    mov bx, name    ; char* buffer
    call READ_STR

    mov bx, name
    call PRINT_STR

    jmp $   ; loop forever

PRINT_STR:
    mov ah, 0xE     ; teletype mode
    mov al, [bx]    ; char to print
    test al, 0xFF   ; check for '\0'
    jnz PRINT_NEXT
    ret
PRINT_NEXT:
    int 0x10    ; BIOS interrupt
    inc bx
    jmp PRINT_STR

READ_STR:
    mov ah, 0   ; wait for key press
    int 0x16    ; BIOS interrupt
    cmp al, '.'
    jne READ_NEXT
    ret
READ_NEXT:
    mov [bx], al
    inc bx
    jmp READ_STR


    textToPrint1: db "Enter name: ", 0
    name: times 32 db 0

    times 510-($-$$) db 0   ; padding zeros
    db 0x55, 0xAA           ; mark end of boot sector
