BITS 16
ORG 0x8000

start:
    mov ax, 0
    mov ds, ax

main_loop:
    call prompt
    call read_line_with_echo
    call print_newline           ; newline after Enter
    call print_line              ; print typed text
    call print_newline           ; another newline
    jmp main_loop

; ------------------------------
prompt:
    mov si, prompt_msg
.print_char:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .print_char
.done:
    ret

prompt_msg db 'avi: ',0

; ------------------------------
read_line_with_echo:
    mov di, input_buffer
.read_char:
    mov ah, 0x00
    int 0x16                 ; BIOS read key
    cmp al, 0x0D             ; Enter?
    je .done
    ; echo character as typed
    mov ah, 0x0E
    int 0x10
    stosb                     ; store in buffer
    jmp .read_char
.done:
    mov al, 0                 ; null terminate string
    stosb
    ret

; ------------------------------
print_newline:
    mov al, 0x0D              ; carriage return
    mov ah, 0x0E
    int 0x10
    mov al, 0x0A              ; line feed
    mov ah, 0x0E
    int 0x10
    ret

; ------------------------------
print_line:
    mov si, input_buffer
.print_loop:
    lodsb
    cmp al, 0
    je .done_line
    mov ah, 0x0E
    int 0x10
    jmp .print_loop
.done_line:
    ret

input_buffer times 128 db 0