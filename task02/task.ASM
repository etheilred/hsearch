format pe console
entry start

include 'win32ax.inc'

section '.code' code readable executable
        start:
                cinvoke printf, queryN
                cinvoke scanf, integerIn, N
                cinvoke printf, queryArr

                mov eax, A
                mov edx, [N]
                stdcall readArr

                cinvoke printf, newline


                mov eax, A
                mov edx, [N]
                stdcall printArr

                jmp exit


        exit:
                call [getch]
                call [ExitProcess]

        ;;; Reads array from stdin
        proc readArr uses eax edx  ; eax - pointer to array, edx - array size
        lp1:
                lp:
                        push edx
                        push eax
                        cinvoke scanf, integerIn, eax
                        pop eax
                        pop edx
                        add eax, 4
                        dec edx
                        jnz lp
                ret
        endp

        ;;; Displays array to stdout
        proc printArr uses eax edx  ; eax - pointer to array, edx - array size
        lp2:
                push eax
                push edx
                cinvoke printf, integerOut, dword [eax]
                pop edx
                pop eax
                add eax, 4
                dec edx
                jnz lp2
                ret
        endp

section '.data' data readable writeable
        queryN db 'Enter A size: ', 0
        queryArr db 'Enter A elements: ', 0
        newline db 13, 0
        N dd ?
        integerIn db '%d', 0
        integerOut db '%d ', 0
        character db '%c', 0
        A rd 256
        B rd 256

section '.idata' import data readable
        library kernel32, 'KERNEL32.DLL',\
                msvcrt, 'msvcrt.dll'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'

        import kernel32,\
               ExitProcess, 'ExitProcess'