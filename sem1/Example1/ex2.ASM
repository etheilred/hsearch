format PE console
entry start

include 'win32a.inc'

section '.code' code readable executable
start:
        mov [name], 0
        mov [surname], 0

        push enterName
        call [printf]

        push name
        push strFormat
        call [scanf]

        push enterSurname
        call [printf]

        push surname
        push strFormat
        call [scanf]

        push surname
        push name
        push greetFormat
        call [printf]

        call [getch]

        invoke ExitProcess, 0

section '.data' data readable writeable
        name rb 100
        surname rb 100
        A dd ?
        enterName db 'Enter your name: ',0
        enterSurname db 'Enter your surname: ' ,0
        strFormat db '%s'    ,0
        greetFormat db 'Hello, %s %s' ,0

section '.idata' import data readable
        library kernel32, 'KERNEL32.DLL',\
                msvcrt, 'msvcrt.dll'

        import msvcrt,\
                printf, 'printf',\
                scanf, 'scanf',\
                getch, '_getch'

        import kernel32,\
                ExitProcess, 'ExitProcess'
