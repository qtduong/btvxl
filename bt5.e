.model small
.stack 100h
.data
    msg1 db 'Nhap N (1 <= N <= 9): $'
    msg2 db 'Gia tri S = $'
    N db ?
    S dw 0
    i db 1

.code
main:
    ; Khởi tạo các thanh ghi
    mov ax, @data
    mov ds, ax

    ; Nhập N từ bàn phím
    lea dx, msg1
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'  ; Chuyển đổi từ ký tự sang số
    mov N, al

    ; Kiểm tra N có hợp lệ không
    cmp N, 1
    jl invalid
    cmp N, 9
    jg invalid

    ; Tính S = 0
    xor ax, ax   ; S = 0

    ; Vòng lặp từ 1 đến N
loop_start:
    mov bl, i      ; BL = i
    mov al, bl     ; AL = i
    mul al         ; AX = AL * AL
    mul al         ; AX = AL * AL * AL (tính i^3)
    add S, ax      ; S += i^3

    inc i          ; i++
    cmp i, N       ; so sánh i với N
    jle loop_start ; nếu i <= N, quay lại loop_start

    ; In S ra màn hình
    lea dx, msg2
    mov ah, 09h
    int 21h

    mov ax, S
    call PrintNumber ; gọi hàm in số

    ; Kết thúc chương trình
    mov ax, 4C00h
    int 21h

invalid:
    ; Thông báo N không hợp lệ
    mov dx, offset msg_invalid
    mov ah, 09h
    int 21h
    jmp main

; Hàm in số (S) ra màn hình
PrintNumber proc
    push ax
    push bx
    push cx
    push dx

    ; Chia số thành từng chữ số
    mov cx, 0       ; Đếm số chữ số
next_digit:
    xor dx, dx      ; Đặt lại dx
    mov bx, 10
    div bx           ; Chia ax cho 10
    push dx          ; Lưu lại phần dư
    inc cx           ; Tăng đếm
    test ax, ax
    jnz next_digit

    ; In từng chữ số
print_loop:
    pop dx           ; Lấy chữ số từ stack
    add dl, '0'      ; Chuyển đổi thành ký tự
    mov ah, 02h
    int 21h          ; In ký tự
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintNumber endp

end main


