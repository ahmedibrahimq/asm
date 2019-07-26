Title
.MODEL SMALL
.STACK
.DATA
    STR_I    DB 31 DUP("$")
    STR_O    DB 31 DUP("$")
    STR_END  DB "$"
    _LENGTH  DW 0000
.CODE
    MAIN PROC FAR
        MOV AX,@Data
        MOV DS,AX
        ;-----------
        CALL READ_STR
        CALL STR_LENGTH
        
        LEA SI, STR_I
        LEA DI, STR_O
        
        ADD SI,_LENGTH
        SUB SI,1
        MOV CX,_LENGTH
        
        REVERSE:
            MOV DH,[SI]
            MOV [DI],DH
            INC DI
            DEC SI
            DEC CX
            JNZ REVERSE
            
      MOV AH,09H                                                                                                                                                                                                                                                                                                                                
      LEA DX,STR_O
      INT 21H
        ;-----------
        MOV AX,4C00H
        INT 21H
    MAIN ENDP
    
    ;----------------------------
    
        READ_STR PROC NEAR
            MOV CX,30 ;LENGTH LIMITS
            LEA DI,STR_I
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
            
            STR_LENGTH PROC NEAR
                LEA BX,STR_I
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
