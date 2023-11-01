SECTION .text
    global outb
    outb:   ; void outb(unsigned short port, unsigned char val)
        push ebp
        mov ebp, esp
        
        mov edx, [ebp+8]
        mov eax, [ebp+12]

        out dx, al

        mov esp, ebp
        pop ebp
        ret

    global inb
    inb:    ; unsigned char inb(unsigned short port)
        push ebp
        mov ebp, esp

        mov edx, [ebp+8]

        in al, dx

        mov esp, ebp
        pop ebp
        ret