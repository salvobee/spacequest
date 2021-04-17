;------------------------------------------------------------
;BuildScreen
;creates a screen from level data
;------------------------------------------------------------
; La routine inzia con il puntare all'area di memoria dove sono
; contenuti i dati del livello (in questo caso LEVEL_1)
; I dati sono sequenze di 6 bytes con memorizzati secondo il seguente schema: 
; Level Data Scheme: OBJ_TYPE,Posizione Iniziale X ,Posizione Iniziale Y,Lunghezza,Carattere con cui disegnarlo,Colore

!zone BuildScreen
BuildScreen
          lda #0 ; carattere da usare per svuotare lo schermo
          ldy #6 ; colore utilizzato
          jsr ClearPlayScreen

          ;get pointer to real level data from table
          ldx LEVEL_NR
          lda SCREEN_DATA_TABLE,x
          sta ZEROPAGE_POINTER_1
          lda SCREEN_DATA_TABLE + 1,x
          sta ZEROPAGE_POINTER_1 + 1
          
          jsr .BuildLevel

		  ; ripete la routine per disegnare i bordi del livello
          ;get pointer to real level data from table
          lda #<LEVEL_BORDER_DATA
          sta ZEROPAGE_POINTER_1
          lda #>LEVEL_BORDER_DATA
          sta ZEROPAGE_POINTER_1 + 1
          
          jsr .BuildLevel
          rts
          
.BuildLevel
          ;work through data
          ldy #255
          
.LevelDataLoop
          iny
          
          lda (ZEROPAGE_POINTER_1),y
          cmp #LD_END
          beq .LevelComplete
          cmp #LD_LINE_H
          beq .LineH
          cmp #LD_LINE_V
          beq .LineV
          
.LevelComplete          
          rts
          
.NextLevelData
          pla
          
          ;adjust pointers so we're able to access more 
          ;than 256 bytes of level data
          clc
          adc #1
          adc ZEROPAGE_POINTER_1
          sta ZEROPAGE_POINTER_1
          lda ZEROPAGE_POINTER_1 + 1
          adc #0
          sta ZEROPAGE_POINTER_1 + 1
          ldy #255
          
          jmp .LevelDataLoop

.LineH
          ;X pos
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM1 
          
          ;Y pos
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM2

          ;width
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM3
          
          ;char
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM4
          
          ;color
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM5
          
          ;store target pointers to screen (ZP_PT2) and color ram (ZP_PT3)
          ldx PARAM2
          lda SCREEN_LINE_OFFSET_TABLE_LO,x
          sta ZEROPAGE_POINTER_2
          sta ZEROPAGE_POINTER_3
          lda SCREEN_LINE_OFFSET_TABLE_HI,x
          sta ZEROPAGE_POINTER_2 + 1
		  
		  
		  ; SCREEN_COLOR = $d800
		  ; SCREEN_CHAR = $CC00
		  ; $d800 - $cc00 = $c00 AND $ff00 = $c00 RSL 8 = $0C
		  ; aggiungendo questo valore al byte alto del puntatore
		  ; sulla screen ram otteniamo il corretto byte alto
		  ; del puntatore della color ram
          clc
          adc #( ( SCREEN_COLOR - SCREEN_CHAR ) & 0xff00 ) >> 8
          sta ZEROPAGE_POINTER_3 + 1
          
		  ; salviamo la posizione del contatore di byte letti nello stack
          tya
          pha
          
          ldy PARAM1
.NextChar     
		  ; utilizziamo la posizione X del carattere per indirizzare la giusta colonna
          lda PARAM4
          sta (ZEROPAGE_POINTER_2),y
          lda PARAM5
          sta (ZEROPAGE_POINTER_3),y
          iny
          dec PARAM3
          bne .NextChar
          
          jmp .NextLevelData
          
.LineV
          ;X pos
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM1 
          
          ;Y pos
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM2

          ;height
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM3
          
          ;char
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM4
          
          ;color
          iny
          lda (ZEROPAGE_POINTER_1),y
          sta PARAM5
          
          ;store target pointers to screen and color ram
          ldx PARAM2
          lda SCREEN_LINE_OFFSET_TABLE_LO,x
          sta ZEROPAGE_POINTER_2
          sta ZEROPAGE_POINTER_3
          lda SCREEN_LINE_OFFSET_TABLE_HI,x
          sta ZEROPAGE_POINTER_2 + 1
          clc
          adc #( ( SCREEN_COLOR - SCREEN_CHAR ) & 0xff00 ) >> 8
          sta ZEROPAGE_POINTER_3 + 1
          
          tya
          pha
          
          ldy PARAM1
.NextCharV         
          lda PARAM4
          sta (ZEROPAGE_POINTER_2),y
          lda PARAM5
          sta (ZEROPAGE_POINTER_3),y
          
		  ; nel caso delle linee verticali, viene aggiunto l'offset
		  ; di una riga (40 colonne) 
		  ;decrementando la lunghezza e ripetendo fino a quando non arriviamo a zero
          ;adjust pointer
          lda ZEROPAGE_POINTER_2
          clc
          adc #40
          sta ZEROPAGE_POINTER_2
          sta ZEROPAGE_POINTER_3
          lda ZEROPAGE_POINTER_2 + 1
          adc #0
          sta ZEROPAGE_POINTER_2 + 1
          clc
          adc #( ( SCREEN_COLOR - SCREEN_CHAR ) & 0xff00 ) >> 8
          sta ZEROPAGE_POINTER_3 + 1
          
          dec PARAM3
          bne .NextCharV
          
          jmp .NextLevelData
          
          



;------------------------------------------------------------
;clears the play area of the screen
;A = char
;Y = color
;------------------------------------------------------------

!zone ClearPlayScreen
ClearPlayScreen
            ldx #$00
.ClearLoop          
            sta SCREEN_CHAR,x
            sta SCREEN_CHAR + 220,x
            sta SCREEN_CHAR + 440,x
            sta SCREEN_CHAR + 660,x
            inx
            cpx #220
            bne .ClearLoop
            
            tya
            ldx #$00
.ColorLoop          
            sta $d800,x
            sta $d800 + 220,x
            sta $d800 + 440,x
            sta $d800 + 660,x
            inx
            cpx #220
            bne .ColorLoop
            
            rts