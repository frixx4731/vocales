TITLE Cadena
.286
INCLUDE libro.inc
.model small

.STACK

.data
    ln DB 0DH, 0AH, '$'
    let4 DB 'Ingresa una cadena: ', '$'
    vocal DB 'aeiou', '$'

    let2 DB 'No se encontro en la cadena', '$'
    caracter db 0
    pos_vocal db 0
    array1 DB 40 DUP(?)
    long_array1 EQU $ - array1
    respuesta db 'Salir|Reiniciar', '$'
    cerrar db 'Quiere seguir, seleccione la inical de cada opcion', '$'

.code
    PRINC PROC FAR
    MOV AX, @data
    MOV DS, AX
    MOV ES, AX
    
palabra:   
    pos_puntero 0, 0, 0
    write let4
    pos_puntero 0, 0, 1
    MOV CX, 40
    MOV BX, OFFSET array1
    CALL leer_cadena

    CALL verificar_mouse

reiniciar:
    pos_puntero 0, 0, 3
    write vocal

    pos_puntero 0, 10, 5
    write cerrar

    pos_puntero 0, 0, 7
    write respuesta

consultar:
    CALL mostrar_cursor
    CALL rastrear_cursor
    
    CMP BX, 1
    JE izquierda
    CMP BX, 2
    JMP consultar

izquierda:
    MOV AX, CX
    CALL obtener_coordenada
    MOV CL, AL

    MOV AX, DX
    CALL obtener_coordenada
    MOV DL, AL

    CMP DL, 3
    JE vocales
    CMP DL, 7
    JE btn_cerrar
    JMP consultar

btn_cerrar:
    CMP CL, 0
    JE finalizar
    CMP CL, 6
    JE ingresar
    JMP consultar

finalizar:
    JMP fin

ingresar:
    CALL ocultar_cursor
    CALL limpiar_pantalla
    JMP palabra

vocales:
    CMP CL, 0
    MOV AL, 'a'
    JE comparar
    CMP CL, 1
    MOV AL, 'e'
    JE comparar
    CMP CL, 2
    MOV AL, 'i'
    JE comparar
    CMP CL, 3
    MOV AL, 'o'
    JE comparar
    CMP CL, 4
    MOV AL, 'u'
    JE comparar
    JMP consultar

comparar:
    MOV pos_vocal, CL
    MOV DI, OFFSET array1
    CLD
    MOV CX, long_array1
    MOV caracter, AL

buscar: 
    REPNE SCASB
    JE encontrado
    JMP reiniciar
    
encontrado:
    MOV DX, DI
    LEA BX, array1
    SUB DX, BX
    SUB DL, 1
    color DL, DL, 1, 1
    CALL ocultar_cursor
    color pos_vocal, pos_vocal, 3, 3 
    CALL mostrar_cursor    
    MOV AL, caracter
    JMP buscar

fin:
    CALL ocultar_cursor
    CALL exit

PRINC ENDP

leer_cadena PROC
    MOV SI, 0
llenar_cadena:
    CALL sonido  
    MOV AH, 01h          ; Solicitar un car?cter al usuario
    INT 21h              ; Interrupci?n del sistema para leer el car?cter
    CMP AL, 13           ; Comparar si es igual a la tecla Enter
    JE fin_llenar_cadena ; Si es Enter, finalizar el llenado de la cadena
    MOV array1[SI], AL   ; Guardar el car?cter en la cadena
    INC SI               ; Incrementar el ?ndice
    CMP SI, 40           ; Comprobar si se lleg? al m?ximo
    JAE fin_llenar_cadena; Si se alcanz? el m?ximo, finalizar el llenado
    JMP llenar_cadena    ; Continuar llenando la cadena
fin_llenar_cadena:
    MOV array1[SI], 0    ; A?adir terminador de cadena (car?cter nulo)
    RET
leer_cadena ENDP

limpiar_pantalla PROC
    MOV AH, 06h
    MOV AL, 0
    MOV BH, 07h
    MOV CX, 0
    MOV DX, 184Fh
    INT 10h
    RET
limpiar_pantalla ENDP

END PRINC