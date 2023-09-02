section .text
    [global outb]
    [global inb]

    outb:
        push ebp
        mov ebp, esp
        
        mov edx, [ebp+8]
        mov eax, [ebp+12]

        out dx, al

        mov esp, ebp
        pop ebp
        ret

    inb:
        push ebp
        mov ebp, esp

        mov edx, [ebp+8]

        in al, dx

        mov esp, ebp
        pop ebp
        ret