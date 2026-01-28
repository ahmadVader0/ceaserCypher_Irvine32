INCLUDE Irvine32.inc

.data
    ; Program logo
    programLogo BYTE \
    "====================================",13,10,
    "            CAESAR CIPHER           ",13,10,
    "        Assembly Language (x86)     ",13,10,
    "====================================",13,10,0

    ; Menu text
    menuText BYTE \
    13,10,
    "1. Encrypt Text",13,10,
    "2. Decrypt Text",13,10,
    "3. Exit Program",13,10,
    "Enter your choice: ",0

    ; Prompts
    inputTextMsg  BYTE "Enter text: ",0
    inputKeyMsg   BYTE "Enter shift key (0-25): ",0
    encryptMsg    BYTE "Encrypted text: ",0
    decryptMsg    BYTE "Decrypted text: ",0
    invalidMsg    BYTE "Invalid choice!",13,10,0

    ; Variables
    textBuffer BYTE 100 DUP(0)
    shiftKey   DWORD ?
    userChoice DWORD ?

.code
main PROC
MainMenu:
    call DisplayMenu
    call ReadInt
    mov userChoice, eax

    cmp userChoice, 1
    je EncryptOption
    cmp userChoice, 2
    je DecryptOption
    cmp userChoice, 3
    je ExitProgram

    mov edx, OFFSET invalidMsg
    call WriteString
    jmp MainMenu

EncryptOption:
    call GetUserInput
    call EncryptText
    jmp MainMenu

DecryptOption:
    call GetUserInput
    call DecryptText
    jmp MainMenu

ExitProgram:
    exit
main ENDP

; -------------------------------------
; Displays program logo and menu
; -------------------------------------
DisplayMenu PROC
    call Clrscr
    mov edx, OFFSET programLogo
    call WriteString
    mov edx, OFFSET menuText
    call WriteString
    ret
DisplayMenu ENDP

; -------------------------------------
; Gets text and key from user
; -------------------------------------
GetUserInput PROC
    mov edx, OFFSET inputTextMsg
    call WriteString
    mov edx, OFFSET textBuffer
    mov ecx, SIZEOF textBuffer
    call ReadString

    mov edx, OFFSET inputKeyMsg
    call WriteString
    call ReadInt
    mov shiftKey, eax
    ret
GetUserInput ENDP

; -------------------------------------
; Encrypts text using Caesar Cipher
; -------------------------------------
EncryptText PROC
    mov esi, OFFSET textBuffer
    mov eax, shiftKey
    call CaesarCipherCore

    mov edx, OFFSET encryptMsg
    call WriteString
    mov edx, OFFSET textBuffer
    call WriteString
    call Crlf
    ret
EncryptText ENDP

; -------------------------------------
; Decrypts text using Caesar Cipher
; -------------------------------------
DecryptText PROC
    mov esi, OFFSET textBuffer
    mov eax, shiftKey
    neg eax
    call CaesarCipherCore

    mov edx, OFFSET decryptMsg
    call WriteString
    mov edx, OFFSET textBuffer
    call WriteString
    call Crlf
    ret
DecryptText ENDP

; -------------------------------------
; Core Caesar Cipher logic
; ESI = text address
; EAX = shift value
; -------------------------------------
CaesarCipherCore PROC
ProcessChar:
    mov al, [esi]
    cmp al, 0
    je CipherDone

    cmp al, 'a'
    jb CheckUpperCase
    cmp al, 'z'
    ja CheckUpperCase

    sub al, 'a'
    add al, al
    add al, 26
    mov bl, 26
    div bl
    mov al, ah
    add al, 'a'
    mov [esi], al
    jmp NextChar

CheckUpperCase:
    cmp al, 'A'
    jb NextChar
    cmp al, 'Z'
    ja NextChar

    sub al, 'A'
    add al, al
    add al, 26
    mov bl, 26
    div bl
    mov al, ah
    add al, 'A'
    mov [esi], al

NextChar:
    inc esi
    jmp ProcessChar

CipherDone:
    ret
CaesarCipherCore ENDP

END main
