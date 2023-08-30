    [org 0x7C00]    ; memory addressing origin

    mov [BOOT_DISK], dl   ; store boot disk number

    ; set up stack
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov bp, 0x8000
    mov sp, bp
    mov bx, 0x7E00

    ; read disk
    mov ah, 2
    mov al, 1           ; number of sectors to read
    mov ch, 0           ; cylinder number
    mov cl, 2           ; sector number
    mov dh, 0           ; head number
    mov dl, [BOOT_DISK]   ; drive number
    int 0x13            ; BIOS interrupt

    ; check CF
    jnc test_num_of_sectors_read
    push eax
    mov eax, CF_ERROR_MSG
    call print_str
    pop eax

    ; check AL
test_num_of_sectors_read:
    cmp al, 1
    je endless_loop
    mov eax, AL_ERROR_MSG
    call print_str

endless_loop
    jmp $   ; loop forever

print_str:  ; ptr to string in ax
    mov bl, [eax]
    cmp bl, 0   ; check end of string
    je end_print_str
    pusha
    call print_chr
    popa
    inc eax
    jmp print_str
end_print_str:
    ret

read_chr:   ; store in bx
    xor bx, bx  ; clear bx
    mov ah, 0
    int 0x16
    mov bl, al
    ret

print_chr:  ; print from bx
    mov ah, 0xE
    mov al, bl
    int 0x10
    ret
    
    BOOT_DISK: db 0
    CF_ERROR_MSG: db "Error reading disk",0xA,0XD,0
    AL_ERROR_MSG: db "Invalid number of sectors read",0xA,0xD,0

    times 510-($-$$) db 0   ; padding zeros
    dw 0xAA55               ; mark end of boot sector
    times 512 db 'P'
