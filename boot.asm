BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [boot_drive], dl

    mov bx, 0x8000        ; load address of kernel
    mov dh, 1             ; number of sectors
    call disk_load

    jmp 0x0000:0x8000     ; jump to kernel

disk_load:
    pusha
    mov ah, 0x02
    mov al, dh
    mov ch, 0
    mov dh, 0
    mov cl, 2             ; sector 2 = kernel
    mov dl, [boot_drive]
    int 0x13
    jc disk_error
    popa
    ret

disk_error:
    jmp $

boot_drive db 0

times 510-($-$$) db 0
dw 0xAA55