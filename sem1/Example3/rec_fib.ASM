format PE console
entry start

include 'win32a.inc'

section '.code' code readable executable
start:
        push query
        call [printf]

        push n
        push integer
        call [scanf]

        mov eax, [n]
        call fibonacci


        push eax
        push [n]
        push output
        call [printf]

        call [getch]
        call [ExitProcess]


fibonacci:
        push ebx
        xor ebx, ebx
        call .fibonacci
        mov eax, ebx
        pop ebx
        jmp .close
.fibonacci:
        cmp eax, 0
        je .close
        cmp eax, 1
        je .return
        push eax
        dec eax
        call .fibonacci
        pop eax
        dec eax
        dec eax
        call .fibonacci
        jmp .close
.return:
        inc ebx
.close:
        ret

section '.data' data readable writeable
        query db "Enter n: ",0
        n dd 5
        integer db "%i", 0
        output db "Fib #%i = %i",0

section '.idata' import data readable
        library kernel32, 'KERNEL32.DLL',\
                msvcrt, 'msvcrt.dll'

        import msvcrt,\
                printf, 'printf',\
                scanf, 'scanf',\
                getch, '_getch'

        import kernel32,\
                ExitProcess, 'ExitProcess'