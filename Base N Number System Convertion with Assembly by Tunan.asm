data segment
    ; add your data here!
    pkey db "press any key...$"
    octal db 5 dup(?)
    hex db 5 dup(?) 
    bin db 2 dup(?)
    m1 db 'Please enter a two digit number: $'  ; input string
    m2 db 'Press 1: convert to octal$'
    m3 db 'Press 2: convert to hexadecimal$'
    m4 db 'Press 3: convert to binary$'
    
    m5 db 'Press 1: convert to Decimal$'
    m6 db 'Press 2: convert to Octal$'
    m7 db 'Press 3: convert to Binary$' 
    
    m8 db 'Press 1: convert to Decimal$'
    m9 db 'Press 2: convert to Octal$'
    m10 db 'Press 3: convert to hexadecimal$'   
    
    m11 db 'Press 1: convert to Decimal$'
    m12 db 'Press 2: convert to Binary$'
    m13 db 'Press 3: convert to hexadecimal$' 
    
    
    
    
    press db 'Press: $'
    result db 'Result: $'
    
    msg1 db 'Press 1: Enter Decimal$'
    msg2 db 'Press 2: Enter  hexadecimal$'
    msg3 db 'Press 3: Enter  binary$'
    msg4 db 'Press 4: Enter  octal$'
    
    errormsg db 'wrong input of digit$'
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    
    ; showing options as string of each type of data to input
    ; loading the strings in dx and printing
    LEA DX,msg1
    mov AH,9
    int 21h
    
    call New_Line; function made to go to next line
    
    LEA DX,msg2
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,msg3
    mov AH,9
    int 21h
    
    call New_Line  
     
    LEA DX,msg4
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,press
    mov AH,9
    int 21h
    
    ; input of which type of digit
    mov ah,1
    int 21h
    mov cl, al
    sub cl,30h
    call New_Line
    
    
    
    call New_Line
    
    ;showing the digit enter message by loading string into dx
    LEA DX,m1
    mov AH,9
    int 21h
    
    
    
    ; checking to see if my input is of decimal or hex or binary
    cmp cl, 1
    je Decimal
    cmp cl, 2
    je hexa 
    cmp cl, 3
    je binary
    jmp  octal_
    
    
    
    
    
    dec_to_bin:
    
    ; taking the input into al again because i need to divide it with 2.
    mov al,bl
    mov ah,0
    mov bx, 2
    mov dx, 0 ; dx will have my remainder
    mov cx, 0
    
    again:
    div bx ; dividing with 2 in a loop
    push dx  ; pushing the remainder into stack
    mov ah,0
    inc cx
    cmp ax,0 ; comparing if ax becomes zero. if it is then i am stopping the loop
    jne again
    
    disp:
    pop dx ; popping remainder to show my binary output
    add dx, 30h ; adding 30h so that the remainder gets the correct ascii value to print
    mov ah,2   ; printing
    int 21h
    
    loop disp  ; using loop to pop all the remainder
    jmp exit
    
    
    dec_to_octal: 
    
    ; taking my input into dl
    mov dl,bl
    ; i used an array to store my remainders 
    mov si,0   
    
    mov al, bl   ; taking bl into al to do division
    mov ah,0
    mov bl, 8h
    div  bl 
    
    mov octal[si], ah   ; taking the first remainder into array
    inc si
    
    mov al, al
    mov ah,0
    div bl
    
    mov octal[si], ah   ; taking the 2nd remainder into array
    
    mov cx, 2    ; loop size 2 because i have 2 remainders
    mov ah , 2
    mov si,1    ; printing the remainders backwards to get my output
    
    cmp dl, 40h ; since all my inputs of 2 digits. the max output can have a 1 in front. so i am checking if my input value is with 100 number or not
    jg a1
    
    L2:
    add octal[si], 30h ; looping to print the output
    mov dl , octal[si]
    int 21h
    dec si    ; decrementing because I have to print it backwards
    
    Loop L2
    jmp exit
    
    
    
              
     
    dec_to_hex: 
    
    ; i used an array to store my remainders
    mov si,0
    
    mov al, bl   ;taking bl into al to do division
    mov ah,0
    mov bl, 10h
    div  bl 
    
    mov hex[si], ah    ; taking the first remainder into array
    inc si
    
    mov al, al
    mov ah,0
    div bl
    
    mov hex[si], ah     ; taking the 2nd remainder into array
    
    mov cx, 2        ;loop size 2 because i have 2 remainders
    mov ah , 2
    mov si,1        ; printing the remainders backwards to get my output
    
    
    
    L3:
    
    add hex[si], 30h   ; addimg 30h to get my output
    mov dl , hex[si]
    int 21h
    dec si
    ; checking if 2nd remainder is of A-F
    cmp hex[si], 10  
    je A
    cmp hex[si], 11
    je B
    cmp hex[si], 12
    je C 
    cmp hex[si], 13
    je D
    cmp hex[si], 14
    je E
    cmp hex[si], 15
    je F
    
    Loop L3
    jmp exit
     
    
    hex_to_dec:
    ;clearing cx and dx
    mov cx, 0 
    mov dx, 0
    
    
    mov al,bl  ; taking my stored input bl into al
    mov ah,0
    
    ;conveting to decimal
    conversion:
    mov bl, 0Ah    ; dividing with A(10) to get my remainders
    div bl 
    
    
    mov bx, ax
    mov ah,0
    
    ;checking if the value of al is from A-F in case the output is of three digits and printing.
    cmp al, 9h
    jg A2
    
    ;adding 30h to get the actual digit while showing output
    add bh, 30h
    add bl, 30h
    
    ;printing my output
    mov ah, 2
    mov dl, bl
    int 21h
    mov ah, 2
    mov dl, bh
    int 21h
    
    jmp exit
    
    hex_to_octal: 
    
    ;clearing cx and dx
    mov cx, 0
    mov dx, 0
    
    
    mov ax,bx ;taking my stored input bx into ax
    mov ah,0
    
    cmp al, 3Fh  ; this is the highest value with 2 digit decimal value. so im comparing my input with 3fh to divide my conversion method into two parts
    jg conversion2
    
    ;conveting to octal
    conversion1:
    mov bl, 08h   ; dividing with 08h to get remainders
    div bl
     
    
    
    mov bx, ax
    mov ah,0
    
    ;checking if the value of al is from A-F in case the output is of three digits and printing.
    cmp al, 9h
    jg A2
    
    add bh, 30h  ;adding 30h to print correct values
    add bl, 30h
    
    mov ah, 2
    mov dl, bl
    int 21h
    mov ah, 2
    mov dl, bh
    int 21h
    jmp exit
    
    conversion2:    
    
    ;using array to store my quotent and remainders
    mov si,0
    mov bl, 08h
    div bl
    mov octal[si], al
    inc si
    mov al , ah
    mov ah,0
    div bl
    mov octal[si], ah
    inc si
    mov octal[si], al
    
    mov cx, 2
    mov ah , 2
    mov si,2
    
    cmp dl, 40h
    jg a1
    
    L4:
    add octal[si], 30h
    mov dl , octal[si]
    int 21h
    dec si
    
    Loop L4
    jmp exit
    
    hex_to_bin1:
    
    ;taking my input bl into al
    mov al,bl
   
    
    mov ah,0
    mov bx, 2
    mov dx, 0
    mov cx, 0
    
    
    ; using loop to to get my remainders
    again4:
    div bx
    push dx  ;pushing remainder into stack
    mov ah,0
    inc cx
    cmp ax,0
    jne again4
    
    disp4:
    pop dx   ; popping from stack and putting in dx for output
    add dx, 30h
    mov ah,2
    int 21h
    
    loop disp4
    jmp exit
    
    
    
    hex_to_bin:
    
    ;this is different from previous because this has either A-F in the input. So here i divide them as as different digit like 1F to 1 and F and then convert them seperately
    mov si,0
    mov al, bin[si] ; used array to store my individual values
    mov ah,0
    mov bx, 2
    mov dx, 0
    mov cx, 0
    
    ; using loop like before
    again1:
    div bx
    push dx
    mov ah,0
    inc cx
    cmp ax,0
    jne again1
    
    disp1:
    pop dx
    add dx, 30h
    mov ah,2
    int 21h
    
    loop disp1
    
    mov si,1
    
    ;taking the 2nd part from the array and showing the binary of that digit
    mov al, bin[si]
    mov ah,0
    mov bx, 2
    mov dx, 0
    mov cx, 0
    
    again2:
    div bx
    push dx
    mov ah,0
    inc cx
    cmp ax,0
    jne again2
    
    disp2:
    pop dx
    add dx, 30h
    mov ah,2
    int 21h
    
    loop disp2
    jmp exit
    
    
    binary_con:
    
    ; since the input can be of 2 digits only, the binary inputs can only be in this 4 combinations. so i am comparing which input it is and printing the corresponding hex/octal/decimal values.
    cmp al, 00h
    je print_0
    cmp al, 01h
    je print_1
    cmp al, 10h
    je print_2
    cmp al, 11h
    je print_3
    
    
    
        
    
    exit:
    mov ax, 4c00h ; exit to operating system.
    int 21h
    
    
    ;used to print new line. this is a functions
    New_Line:
    MOV AH,2 ;display character function
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed

    ret   ; after calling, going back to the line where this instruction was called
    
    
    error:  ; used when input type of binary is any other values than 0 or 1.
    lea dx, errormsg  ; loading the error message
    mov ah,9h
    int 21h
    jmp exit
    
    
    ; printing the corresponding hex/octal/decimal values
    print_0: 
    
    mov ah,2
    mov dl, 30h
    int 21h 
    jmp exit
    print_1: 
    
    mov ah,2
    mov dl, 31h
    int 21h
    print_2: 
    jmp exit
    mov ah,2
    mov dl, 32h
    int 21h
    
    print_3: 
    
    mov ah,2
    mov dl, 33h
    int 21h
    jmp exit    
    
    ; here i am printing the output of A-F by using their ascii values
    A:
    
    mov ah,2
    mov dl, 41h
    int 21h
    jmp exit
    
    B:
    mov ah,2
    mov dl, 42h
    int 21h
    jmp exit   
    
    C:
    mov ah,2
    mov dl, 43h
    int 21h
    jmp exit   
    
    D:
    mov ah,2
    mov dl, 44h
    int 21h
    jmp exit
    
    E:
    mov ah,2
    mov dl, 45h
    int 21h
    jmp exit
    
    F:
    mov ah,2
    mov dl, 46h
    int 21h
    jmp exit 
    
    a1:
    mov ah,2  ; printing a 1 in front while convering from dec to octal
    mov dl, 31h
    int 21h
    jmp l2   
    
    
    ;this is used when my input digit is of A-F when converting from Hex to anyother number type.
    A3:
    mov al, 0Ah       
    mov cl,al
    mov si,1
    mov bin[si], cl   ; taking this into bin array as input
    add al, bl
    mov ah,0 
    mov bl, al
    mov ch,1    ; this is a checker for my input type having A-F
    jmp print
    
     
    B3:
    mov al, 0Bh
    mov cl,al
    mov si,1
    mov bin[si], cl    ; taking this into bin array as input
    add al, bl
    mov ah,0  
    mov bl, al
    mov ch,1     ; this is a checker for my input type having A-F
    jmp print
    
    C3:
    mov al, 0Ch
    mov cl,al
    mov si,1
    mov bin[si], cl      ; taking this into bin array as input
    add al, bl
    mov ah,0  
    mov bl, al
    mov ch,1    ; taking this into bin array as input
    jmp print
    
    D3:
    mov al, 0Dh
    mov cl,al
    mov si,1
    mov bin[si], cl    ; taking this into bin array as input
    add al, bl
    mov ah,0  
    mov bl, al
    mov ch,1         ; taking this into bin array as input
    jmp print
    
    E3:
    mov al, 0Eh
    mov cl,al
    mov si,1
    mov bin[si], cl    ; taking this into bin array as input
    add al, bl
    mov ah,0  
    mov bl, al
    mov ch,1    ; taking this into bin array as input
    jmp print
    
    F3:
    mov al, 0Fh
    mov cl,al
    mov si,1
    mov bin[si], cl    ;taking this into bin array as input
    add al, bl
    mov ah,0  
    mov bl, al
    mov ch,1      ; taking this into bin array as input
    jmp print
    
    
    
    ;
    A2:
    mov cl, 0Ah
    mov ah,0
    div cl
    
    mov cx, ax
    
    mov ah, 2
    add cl, 30h
    mov dl, cl
    int 21h
    add ch, 30h
    mov ah, 2
    mov dl, ch
    int 21h 
    
    add bh, 30h
    mov ah, 2
    mov dl, bh
    int 21h    
    
    A5:
    mov al, 0Ah
    mov cl,al
    mov si,0
    mov bin[si], cl
    add al, bl
    mov ah,0 
    shl al, 4 
    mov bl, al 
    mov ch,1
    jmp next
    
     
    B5:
    mov al, 0Bh
    mov cl,al
    mov si,0
    mov bin[si], cl
    add al, bl
    mov ah,0 
    shl al, 4 
    mov bl, al 
    jmp next
    C5:
    mov al, 0Ch
    mov cl,al
    mov si,0
    mov bin[si], cl
    add al, bl
    mov ah,0  
    shl al, 4 
    mov bl, al
    mov ch,1
    jmp next
    D5:
    mov al, 0Dh
    mov cl,al
    mov si,0
    mov bin[si], cl
    add al, bl
    mov ah,0  
    shl al, 4 
    mov bl, al
    mov ch,1
    jmp next
    
    E5:
    mov al, 0Eh
    mov cl,al
    mov si,0
    mov bin[si], cl
    add al, bl
    mov ah,0  
    shl al, 4 
    mov bl, al
    mov ch,1
    jmp next
    
    F5:
    mov al, 0Fh
    mov cl,al
    mov si,0
    mov bin[si], cl
    add al, bl
    mov ah,0  
    shl al, 4 
    mov bl, al
    mov ch,1
    jmp next
    
    
    
    Decimal: 
    
    ;taking decimal input
    mov ah,1
    int 21h
    sub al, 30h
    
    mov ah,0
    
    mov bl, 10
    mul bl
    
    mov bl, al
    mov ah, 1
    int 21h
    sub al, 30h
    add bl, al
   
    
    
    call New_Line
    
    ;showing options to convert and showing the message of options
    
    LEA DX,m2
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,m3
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,m4
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,press
    mov AH,9
    int 21h
    
    mov ah,1
    int 21h
    mov cl, al
    sub cl,30h
    
    call New_Line
    
    LEA DX,result
    mov AH,9
    int 21h
    
    ;checking to see which conversion to do
    cmp cl, 1
    je dec_to_octal
    cmp cl,2
    je dec_to_hex
    jmp dec_to_bin 
    
    
    hexa: 
    mov ch,0    ; another checker value to find if my hex input is of numerical values only   
    
    mov ah,1     ;input
    int 21h 
    
    ; checking if the first input is fromo A-F
    cmp al, 41h 
    je A5
    cmp al, 42h
    je B5    
    cmp al, 43h
    je C5
    cmp al, 44h
    je D5
    cmp al, 45h
    je E5     
    cmp al, 46h
    je F5
    
    sub al, 30h
    mov si,0
    mov bin[si], al
    mov ah,0
    
    shl al, 4 ;shifting 4 times
    mov bl, al 
    next:
    mov ah, 1    ;input
    int 21h
    
    
    ;comparing if input has A-F values in them
    cmp al, 41h 
    je A3
    cmp al, 42h
    je B3     
    cmp al, 43h
    je C3
    cmp al, 44h
    je D3
    cmp al, 45h
    je E3    
    cmp al, 46h
    je F3
    
    
    sub al, 30h
    add bl, al
    mov al, cl
    add al, bl
    mov ah,0
    
    
    mov si,1
    mov bin[si], cl ; putting both inputs into array to convert them seperately
    
    
    print:
    call New_Line
    
    LEA DX,m5
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,m6
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,m7
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,press
    mov AH,9
    int 21h
    
    mov ah,1
    int 21h
    mov cl, al
    sub cl,30h
    
    call New_Line
    
    LEA DX,result
    mov AH,9
    int 21h
    
    ;checking to see which conversion to do
    cmp cl, 1
    je hex_to_dec
    cmp cl, 2
    je hex_to_octal
    cmp ch, 1
    je hex_to_bin1  ; here i am using that checker to see if my input has A-F or only 0-9 in them. I am using 2 methods to convert each type of input.
    jmp hex_to_bin
    
    
    binary:
    
    mov ah,1 ; taking input
    int 21h
    
    cmp al,31h   ; checking if my first value is greater than 1 and if yes then showing error
    jg error
    
    mov ah,0
    sub al,30h
    shl al, 4
    mov bl, al
    
    mov ah,1  ; taking input
    int 21h
    
    cmp al,31h   ; checking if my 2md value is greater than 1 and if yes then showing error
    jg error
    sub al,30h
    add al, bl
    mov bl, al
    
    
    ;printing the options to convert to
    call New_Line
    
    LEA DX,m8
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,m9
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,m10
    mov AH,9
    int 21h
    
    call New_Line
    
    LEA DX,press
    mov AH,9
    int 21h
    
    mov ah,1
    int 21h
    mov cl, al
    sub cl,30h
    
    call New_Line
    
    LEA DX,result
    mov AH,9
    int 21h
    
         
    
    mov al, bl  ; since this is a two digit input method, so combination is of 4 types, 0-3. this number is consistent for dec,octal and hex. so i used one method to implement this. becuase they all give same ansers
    
    cmp cl,1
    je binary_con
    jmp binary_con
    
    
    octal_: 
        mov ah, 01h
        int 21h
        mov bh, al 
        
        mov ah, 01h
        int 21h
        mov bl, al 
    
        sub bl, 30h
        
        cmp bl, 08h
        je check_8
        cmp bl, 09h
        je check_9
        
        sub bh, 30h
        mov al, 8h
        mul bh
        add al, bl
        mov bl, al   
        
        call New_Line
        
        LEA DX,m11
        mov AH,9
        int 21h
        
        call New_Line
        
        LEA DX,m12
        mov AH,9
        int 21h
        
        call New_Line
        
        LEA DX,m13
        mov AH,9
        int 21h
        
        call New_Line
        
        LEA DX,press
        mov AH,9
        int 21h
        
        mov ah,1
        int 21h
        mov cl, al
        sub cl,30h
        
        call New_Line
        
        LEA DX,result
        mov AH,9
        int 21h
        
        ;checking to see which conversion to do
        cmp cl, 1
        je oct_to_dec
        cmp cl,2
        je oct_to_bin
        jmp oct_to_hex 
        
     oct_to_hex:
        mov al, bl
        mov bh,0
    
      
        mov ah,0
        mov bl, 10h
        div bl
        
        mov bl, al
        mov bh, ah
        
        add bl, 30h
        
        
        mov ah,2
        mov dl, bl
        int 21h
        
        cmp bh, 0Ah 
        je A
        cmp bh, 0Bh
        je B    
        cmp bh, 0Ch
        je C
        cmp bh,0Dh
        je D
        cmp bh, 0Eh
        je E     
        cmp bh, 0Fh
        je F 
        
        add bh, 30h
        mov ah,2
        mov dl, bh
        int 21h   
        
        jmp exit
        
        
        check_8:
        call New_Line
        LEA DX,errormsg
        mov AH,9
        int 21h
        jmp exit
        
        check_9: 
        call New_Line
        LEA DX,errormsg
        mov AH,9
        int 21h
        jmp exit  
         
     oct_to_bin:
            mov al,bl
            mov ah,0
            mov bx, 2
            mov dx, 0
            mov cx, 0
            
            again_ob:
            div bx
            push dx 
            mov ah,0
            inc cx
            cmp ax,0
            jne again_ob
            
            disp_ob:
            pop dx   ; popping from stack and putting in dx for output
            add dx, 30h
            mov ah,2
            int 21h
            
            loop disp_ob 
            jmp exit             
                         
     oct_to_dec:
            mov cx, 0 
            mov dx, 0  
            
            mov al,bl  
            mov ah,0
            
            mov bl, 0Ah 
            div bl 
            mov bx, ax
            mov ah,0 
            
            add bh, 30h
            add bl, 30h
    
            mov ah, 2
            mov dl, bl
            int 21h  
            
            mov ah, 2
            mov dl, bh
            int 21h  
            
            
            
    
    
        
ends

end start ; set entry point and stop the assembler.
