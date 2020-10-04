; ВАРИАНТ 1 - СФОРМИРОВАТЬ МАССИВ В, СОСТОЯЩИЙ ИЗ ПОЛОЖИТЕЛЬНЫХ ЭЛЕМЕНТОВ А

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'array A size: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strPromptVec db 'Enter %d array elements: ', 0
        strScanInt   db '%d', 0
        strVecElemOut  db '%d ', 0

        strArrBOut db 'Array B of %d elements: ', 0
        strArrAOut db 'Array A of %d elements: ', 0
        strNewLine db 10, 0
        strEmpty db 'empty', 0

        vec_size     dd 0
        sum          dd 0
        i            dd 0
        t dd 0
        tmp          dd ?
        tmpStack     dd ?
        B_size dd 0

        ; TASK VARIABLES
        A rd 1000
        B rd 1000
        maxSize dd 1000


;--------------------------------------------------------------------------
section '.code' code readable executable
start:
         call solveTask
finish:
        call [getch]

        push 0
        call [ExitProcess]

; Подпрограмма, содержащая логику выполнения задачи
solveTask:
        ; 1) Считывание массива А
        call VectorInput
        ; 2) Выполнение задания - записываем в B только неотрицательные элементы из А
        call getAllButNegative

        ; 3) Выводим массивы
        push [vec_size]
        push strArrAOut
        call [printf]
        add esp, 8

        mov ebx, A
        mov edx, [vec_size]
        call VectorOut

        push strNewLine
        call [printf]
        add esp, 4

        push [B_size]
        push strArrBOut
        call [printf]
        add esp, 8

        mov ebx, B
        mov edx, [B_size]
        call VectorOut
endSolve:
        ret


;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jle  fail
        cmp eax, [maxSize]
        jg fail
        jmp getVector
; fail size
fail:
        push [vec_size]
        push strIncorSize
        call [printf]
        call [getch]
        push 0
        call [ExitProcess]
; else continue...
getVector:
        push [vec_size]
        push strPromptVec
        call [printf]
        add esp, 8
        xor ecx, ecx            ; ecx = 0
        mov ebx, A            ; ebx = &A
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        mov [i], ecx

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;-----------------------------------------------------------------------
; содержательная процедура, выполняющая задание
getAllButNegative:
        xor ecx, ecx
        mov ebx, A
        mov edx, B
        mov edi, 0   ; размер массива B
noNegLoop:
        cmp ecx, [vec_size]
        jge endAllButNegative
        cmp dword [ebx], 0
        jle noNegLoopStep
        mov eax, [ebx]
        mov dword [edx], eax
        add edx, 4
        inc edi
noNegLoopStep:
        inc ecx
        add ebx, 4
        jmp noNegLoop
endAllButNegative:
        mov [B_size], edi  ; сохраняем размер B
        ret
;-----------------------------------------------------------------------
; Вывод массива B
VectorOut:     ; edx - размер массива, ebx - указатель на массив
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
       ; mov ebx, B           ; ebx = &B
       ; mov edx, [B_size]
        cmp edx, 0
        jg putVecLoop
        push strEmpty
        call [printf]
        add esp, 4
        jmp endOutputVectorExceptional
putVecLoop:
        mov [tmp], ebx
        cmp ecx, edx
        je endOutputVector      ; to end of loop
        mov [i], ecx
        mov [t], edx

        ; output element
        push dword [ebx]
       ; push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        mov edx, [t]
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
endOutputVectorExceptional:
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'