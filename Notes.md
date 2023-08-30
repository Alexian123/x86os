# NASM Notes

**Read character from stdin to 'al'**
```
mov ah, 0x0     ; wait for keypress
int 0x16        ; BIOS interrupt
```

**Print character from 'al' to stdout**
```
mov ah, 0xE     ; teletype mode
int 0x10        ; BIOS interrupt
```

**CHS address**
- C: cylinder number (0,1,2...)
- H: head number (0,1,2...)
- S: sector number (1,2,3...)

**Read disk**
```
mov [BOOT_DISK], dl   ; store boot disk number

; set up stack
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

; es:bx = es*16 + bx = 0x7E00 (where to load the sectors)
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
```

<br>

### My procedures

```
read_chr:   ; store in bx
    xor bx, bx  ; clear bx
    mov ah, 0
    int 0x16
    mov bl, al
    ret
```

```
print_chr:  ; print from bx
    mov ah, 0xE
    mov al, bl
    int 0x10
    ret
```

```
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
```

```
print_int:  ; prints integer in bx
    ; if number only has 1 digit
    cmp bx, 9
    ja more_digits
    add bx, '0'
    call print_chr
    jmp print_int_return
more_digits:
    push 10     ; mark end of digits on stack
    mov ax, bx
    mov bx, 10
loop_digits:
    xor dx, dx  ; clear dx
    div bx
    push dx
    cmp ax, 0   ; no more digits
    je print_digits
    jmp loop_digits
print_digits:
    pop bx
    cmp bx, 10
    je print_int_return
    add bx, '0' 
    call print_chr
    jmp print_digits
print_int_return:
    ret
```

```
read_and_print_str:   ; read enter terminated string and print it (enter inputs only CR for some reason ???)
    mov ecx, buff    ; ptr to text buffer
loop_read_str:
    call read_chr
    cmp bx, 0xD     ; CR
    je exit_loop_read_str
    mov [ecx], bx
    inc ecx
    jmp loop_read_str
exit_loop_read_str:
    mov [ecx], byte 0    ; string terminator '\0'
    call print_str
    ret
print_str:
    mov ecx, buff    ; reset ptr to text buffer
loop_print_str:
    mov bx, [ecx]
    cmp bx, 0
    je exit_loop_print_str
    call print_chr
    inc cx
    jmp loop_print_str
exit_loop_print_str:
    ret
```