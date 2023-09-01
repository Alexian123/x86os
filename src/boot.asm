[org 0x7C00]

KERNEL_LOC equ 0x1000
NUM_SECTORS equ 20    ; number of sectors to read

BOOT_DISK: db 0
mov [BOOT_DISK], dl

; set up stack
xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, KERNEL_LOC

; read disk
mov ah, 0x02
mov al, NUM_SECTORS    ; number of sectors to read
mov ch, 0x00           ; cylinder number
mov cl, 0x02           ; sector number
mov dh, 0x00           ; head number
mov dl, [BOOT_DISK]    ; drive number
int 0x13               ; BIOS interrupt

; check read error (CF)
jnc check_next    ; if no error
mov ebx, CF_ERR_MSG
call print_str
jmp check_fail

check_next:     
; check number of sectors actually read (AL)
cmp al, NUM_SECTORS
je check_pass     ; if no error
mov ebx, AL_ERR_MSG
call print_str

check_fail:
jmp $   ; endless loop

check_pass: 
; continue

mov ah, 0x0
mov al, 0x3
int 0x10    ; text mode

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode

%include 'src/realio.asm'

GDT_Start:
    null_descriptor:
        dd 0
        dd 0
    code_descriptor:
        dw 0xFFFF
        dw 0
        db 0
        db 0x9A
        db 0xCF
        db 0
    data_descriptor:
        dw 0xFFFF
        dw 0
        db 0
        db 0x92
        db 0xCF
        db 0
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1
    dd GDT_Start

[bits 32]
start_protected_mode:
; set up stack and segment registers
mov ax, DATA_SEG
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ebp, 0x90000
mov esp, ebp

jmp KERNEL_LOC

; Error messages
CF_ERR_MSG: db "Error reading disk!",0xA,0xD,0x0
AL_ERR_MSG: db "Invalid number of sectors read!",0xA,0xD,0x0

times 510-($-$$) db 0
dw 0xAA55