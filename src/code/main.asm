;============================================================
; Main runtime loop + IRQ
;============================================================
; Questo file contiene il flusso principale del gioco:
; 1) setup iniziale
; 2) loop cooperativo (fallback)
; 3) IRQ raster (loop reale frame-based)

;------------------------------------------------------------
; Boot sequence
;------------------------------------------------------------
GameStart
jsr disable_restore      ; disabilita combinazione RESTORE/NMI durante il gioco
jsr setup_init           ; prepara VIC, memoria, mappe, sprite, stato iniziale
jsr ShowStartupMenuAndWaitFire ; menu iniziale minimale con attesa FIRE

; Dopo il menu ripristiniamo esplicitamente lo stato gameplay.
; (Il menu nasconde sprite e pulisce lo schermo.)
lda #0
sta SCREEN_NR
jsr init_buildmap
jsr clearbottom
lda #5
sta LIVES
jsr DrawLives
jsr resetplayerpos
lda #1
sta GAME_STATUS

jsr setup_irq            ; installa handler IRQ raster
;setup_irq_nokrnl
;jsr init_sid
jmp *                    ; dopo setup_irq il controllo passa agli interrupt


;------------------------------------------------------------
; GameLoop (fallback/manuale)
;------------------------------------------------------------
; In pratica, con IRQ attivo, la logica gira dentro "irq".
; Questo loop resta utile per debug o setup alternativi.
GameLoop
          jsr WaitFrame
          jsr PlayerControl
          jmp GameLoop


;------------------------------------------------------------
; WaitFrame
;------------------------------------------------------------
; Sincronizza l'esecuzione alla raster line $F8.
; Strategia a due fasi:
; - prima aspetta di NON essere già su $F8,
; - poi aspetta il prossimo arrivo su $F8.
; In questo modo evitiamo doppio trigger nello stesso frame.
!zone WaitFrame
WaitFrame
          lda $d012
          cmp #$F8
          beq WaitFrame

.WaitUntilRasterF8
          lda $d012
          cmp #$F8
          bne .WaitUntilRasterF8
          rts


;------------------------------------------------------------
; IRQ raster con ritorno al kernel
;------------------------------------------------------------
; Qui gira la logica frame-based del player.
irq
          inc $d020              ; bordo++ per profiling visivo tempo IRQ

          lda GAME_STATUS
          beq .SkipGameLogic

          jsr PlayerControl
          jsr checkplayerposition
          ;jsr play_sid

.SkipGameLogic
          dec $d020              ; bordo-- fine profiling
          dec $d019              ; ack IRQ VIC (legacy path)
          jmp $ea31              ; chaining IRQ standard KERNAL


;------------------------------------------------------------
; IRQ raster standalone (senza kernel chain)
;------------------------------------------------------------
irq_nokrnl
          sta $fe                ; salva A
          lda $dc0d              ; ack CIA interrupt source
          stx $fc                ; salva X
          sty $fd                ; salva Y

          inc $d020
          jsr PlayerControl

          lda #$01
          sta $D019              ; ack IRQ raster VIC esplicito

          ldy $fd                ; ripristina Y
          ldx $fc                ; ripristina X
          lda $fe                ; ripristina A
          dec $d020
          rti
