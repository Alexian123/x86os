section .text
    [global outb]
    outb:
        push ebp
        mov ebp, esp
        
        mov edx, [ebp+8]
        mov eax, [ebp+12]

        out dx, al

        mov esp, ebp
        pop ebp
        ret