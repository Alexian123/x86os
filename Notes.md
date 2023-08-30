# NASM Notes

### Basics

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