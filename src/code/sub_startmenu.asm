;============================================================
; Menu di avvio minimale (low RAM / low code size)
;============================================================
; Obiettivo:
; - mostrare titolo e prompt "PRESS FIRE TO START"
; - attendere pressione FIRE su joystick porta 2 ($DC00 bit 4)
; - lasciare un punto chiaro dove agganciare futura musica SID
;
; Note input joystick C64 (porta 2 su $DC00):
; - bit a 0 = tasto premuto
; - FIRE = bit 4 (maschera #%00010000)

MENU_SCREEN_SPACE_CODE      = 32
MENU_TEXT_COLOR             = 1
MENU_BG_COLOR               = 0

!zone ShowStartupMenuAndWaitFire
ShowStartupMenuAndWaitFire
          jsr MenuPrepareVisuals
          jsr MenuDrawStaticTexts

          ;--------------------------------------------------
          ; Hook futura musica SID (menu theme)
          ;--------------------------------------------------
          ; In futuro:
          ; 1) caricare SID in memoria (file esterno)
          ; 2) inizializzare player SID qui
          ; 3) chiamare play routine dentro il loop di attesa
          ;--------------------------------------------------

.WaitFirePress
          lda #$10
          bit $dc00
          bne .WaitFirePress

.WaitFireRelease
          lda #$10
          bit $dc00
          beq .WaitFireRelease

          rts


;------------------------------------------------------------
; Setup visuale base menu
;------------------------------------------------------------
MenuPrepareVisuals
          ; nasconde sprite durante menu
          lda #0
          sta VIC_SPRITE_ENABLE

          ; sfondo nero
          lda #MENU_BG_COLOR
          sta VIC_BACKGROUND_COLOR

          ; pulizia area caratteri (1000 celle)
          lda #MENU_SCREEN_SPACE_CODE
          ldx #0
.ClearChars
          sta SCREEN_CHAR,x
          sta SCREEN_CHAR + 250,x
          sta SCREEN_CHAR + 500,x
          sta SCREEN_CHAR + 750,x
          inx
          cpx #250
          bne .ClearChars

          ; colore testo uniforme
          lda #MENU_TEXT_COLOR
          ldx #0
.ClearColors
          sta SCREEN_COLOR,x
          sta SCREEN_COLOR + 250,x
          sta SCREEN_COLOR + 500,x
          sta SCREEN_COLOR + 750,x
          inx
          cpx #250
          bne .ClearColors

          rts


;------------------------------------------------------------
; Disegno testi statici menu
;------------------------------------------------------------
MenuDrawStaticTexts
          ; Titolo centrato circa: riga 8, colonna 15
          lda #<MENU_TITLE_TEXT
          sta ZEROPAGE_POINTER_1
          lda #>MENU_TITLE_TEXT
          sta ZEROPAGE_POINTER_1+1
          lda #15
          sta PARAM1
          lda #8
          sta PARAM2
          lda #MENU_TITLE_TEXT_LEN
          sta PARAM3
          jsr MenuWriteTextAt

          ; Prompt centrato circa: riga 14, colonna 10
          lda #<MENU_START_TEXT
          sta ZEROPAGE_POINTER_1
          lda #>MENU_START_TEXT
          sta ZEROPAGE_POINTER_1+1
          lda #10
          sta PARAM1
          lda #14
          sta PARAM2
          lda #MENU_START_TEXT_LEN
          sta PARAM3
          jsr MenuWriteTextAt

          rts


;------------------------------------------------------------
; MenuWriteTextAt
;------------------------------------------------------------
; Input:
; - ZEROPAGE_POINTER_1 -> testo in screen code
; - PARAM1 = colonna (0..39)
; - PARAM2 = riga (0..24)
; - PARAM3 = lunghezza testo
;
; Effetto:
; - copia stringa in SCREEN_CHAR alla posizione desiderata
; - imposta anche colore in SCREEN_COLOR
MenuWriteTextAt
          ; calcola puntatore destinazione su screen RAM in ZEROPAGE_POINTER_2
          ldy PARAM2
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_2
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_2+1

          clc
          lda ZEROPAGE_POINTER_2
          adc PARAM1
          sta ZEROPAGE_POINTER_2
          bcc .NoCarryScreen
          inc ZEROPAGE_POINTER_2+1
.NoCarryScreen

          ; puntatore colore (stessa cella + offset SCREEN_COLOR-SCREEN_CHAR)
          clc
          lda ZEROPAGE_POINTER_2
          adc #< (SCREEN_COLOR - SCREEN_CHAR)
          sta ZEROPAGE_POINTER_3
          lda ZEROPAGE_POINTER_2+1
          adc #> (SCREEN_COLOR - SCREEN_CHAR)
          sta ZEROPAGE_POINTER_3+1

          ldy #0
.CopyLoop
          cpy PARAM3
          beq .Done

          lda (ZEROPAGE_POINTER_1),y
          sta (ZEROPAGE_POINTER_2),y

          lda #MENU_TEXT_COLOR
          sta (ZEROPAGE_POINTER_3),y

          iny
          bne .CopyLoop

.Done
          rts


;------------------------------------------------------------
; Dati testo menu (screen code)
;------------------------------------------------------------
MENU_TITLE_TEXT
          !scr "SPACEQUEST"
MENU_TITLE_TEXT_LEN = 10

MENU_START_TEXT
          !scr "PRESS FIRE TO START"
MENU_START_TEXT_LEN = 19
