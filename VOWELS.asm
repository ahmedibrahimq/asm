Title
.MODEL SMALL
.STACK
.DATA
    _STR     DB 31 DUP("$")  
    VOWELS   DB  "AEIOU","$"
    STR_END  DB "$"
    _LENGTH  DW 0000
    I        DB 0
.CODE
    MAIN PROC FAR
        MOV AX,@Data
        MOV DS,AX
        ;-------------
        CALL READ_STR
        CALL STR_LENGTH
        
        LEA SI,VOWELS
        MOV CX,5
        
        IS_VOWEL:
            CALL CMP_VOWEL
            INC SI
            DEC CX
            JNZ IS_VOWEL
        ;-------------
        MOV AX,4C00H
        INT 21H
    MAIN ENDP
    
    ;------------------
    CMP_VOWEL PROC NEAR
        PUSH CX
        MOV CX,_LENGTH
        MOV DH,[SI]
        LEA BX,_STR
        
        FIND_VOWEL:
            CMP [BX],DH
            JE YES
            JMP NO
            YES:
                INC I
            NO:
            INC BX
            DEC CX
            JNZ FIND_VOWEL
        STOP:    
        POP CX
        RET
    CMP_VOWEL ENDP
    ;---------------------
    
    READ_STR PROC NEAR
            MOV CX,30 ;LENGTH LIMITS
            LEA DI,_STR
            READ_CHAR:
                MOV AH,01H
                INT 21H
                
                CMP AL,13   ;IS_ENTER_KEY
                JE _BREAK
                
                MOV [DI],AL
                INC DI
                DEC CX
                JNZ READ_CHAR
            _BREAK:
            RET
            READ_STR ENDP
            
            ;--------------------
            ; Count length of string -- instead of (LENGTH DW $-MYSTRING)
            STR_LENGTH PROC NEAR
                LEA BX,_STR
                MOV DH,STR_END
                A1:
                    CMP [BX],DH
                    JE _END
                    
                    INC _LENGTH
                    
                    INC BX
                    JMP A1
                _END:    
                    RET
            STR_LENGTH ENDP
    
        END MAIN
