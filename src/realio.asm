%ifndef REALIO
    %define REALIO
    print_str:  ; ptr to string in ebx
        mov ah, 0xE
    print_str_loop:
        mov al, [ebx]
        cmp al, 0   ; check end of string
        je end_print_str
        int 0x10
        inc ebx ; next character
        jmp print_str_loop
    end_print_str:
        ret
%endif