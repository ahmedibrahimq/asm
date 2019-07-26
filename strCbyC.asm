    page 60,132
TITLE INPUT SRING (char by char) & PRINT IT  
.MODEL SMALL
.STACK
.DATA
    _Name DB 30 dup("$")
.CODE
    MAIN PROC FAR
        MOV AX,@DATA
        MOV DS,AX
        ;------------
        MOV SI,0 ;    to index array's  (_Name) items
        MOV CL,0 ;    to count length of input (to know how many times it will print)
        READCHAR:
            MOV AH, 10H
            INT 16H
            MOV _NAME+SI, AL ;    store inputted character before overriding AL
            INC SI
            INC CL
            CMP AL,13  ;    (13 => ASCII of Break -enter- Key) stop when enter is pressed
            JE BREAKLN
            CMP SI,30 ;     (30-1 => is the last index of _NAME)
            JL READCHAR ;    stop if index out of range
        BREAKLN :
        MOV SI,0  ;    indexing from _Name[0] to _Name[CL]
        PRINT:
            MOV AH,02H ;    (02H => Displays character),  (09H) displays from address [DX] to ... there's no '$'
            MOV DL,_NAME +SI
            INT 21H
            INC SI
            DEC CL ;        holds number of inputted characters
            JNZ PRINT ;    stop printing at the last stored character
        ;------------
        MOV AX,4C00H
        INT 21H
    MAIN ENDP
END MAIN
