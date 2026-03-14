;============================================================
; Gestione limiti schermo, debug keyboard e cambio schermata
;============================================================
; Questo modulo si occupa di:
; - respawn del player se cade troppo in basso
; - scorciatoie tastiera (debug) per cambiare schermata
; - trigger automatico cambio schermata quando il player
;   raggiunge i bordi orizzontali

;------------------------------------------------------------
; checkplayerposition
;------------------------------------------------------------
; Se lo sprite del player supera Y=200, lo respawna.
; Poi processa input tastiera di debug.
checkplayerposition
	lda VIC_SPRITE_Y_POS
	cmp #200
	bcc .SkipRespawn

	; reset bit X esteso (riporta in area "normale")
	lda #0
	sta VIC_SPRITE_X_EXTEND

	dec LIVES
	jsr DrawLives

	lda LIVES
	beq .GameOver

	jsr init_player
	jmp .SkipRespawn

.GameOver
	jsr ShowGameOverAndWaitFire
	; Restart game
	jmp GameStart

.SkipRespawn
	jmp check_keyboard


;------------------------------------------------------------
; init_player
;------------------------------------------------------------
; Posizione iniziale del player in coordinate tile (x=5,y=5).
init_player
	lda #5
	sta PARAM1
	lda #5
	sta PARAM2
	ldx #0
	jsr CalcSpritePosFromCharPos
	rts


;------------------------------------------------------------
; check_keyboard (debug)
;------------------------------------------------------------
; SPACE: respawn player
; D:     forza schermata precedente
; U:     forza schermata successiva
check_keyboard
	lda #%11111111
	sta CIA1_DDRA
	lda #%00000000
	sta CIA1_DDRB

check_space
	lda #%01111111
	sta CIA1_PRA
	lda CIA1_PRB
	and #%00010000
	beq init_player

check_d
	lda #%11111011
	sta CIA1_PRA
	lda CIA1_PRB
	and #%00000100
	beq loadscreen_left

check_u
	lda #%11110111
	sta CIA1_PRA
	lda CIA1_PRB
	and #%01000000
	beq loadscreen_right
	rts


;------------------------------------------------------------
; checkscreenscroll
;------------------------------------------------------------
; Trigger automatico cambio schermata ai bordi orizzontali.
; Thresholds:
;   Left:  X <= $18 (24) AND X_EXTEND bit 0 == 0
;   Right: X >= $58 (88) AND X_EXTEND bit 0 == 1 ($58 + 256 = 344)
checkscreenscroll
	lda VIC_SPRITE_X_POS
	cmp #$18
	bcc .maybe_left
	cmp #$58
	bcs .maybe_right
	rts

.maybe_left
	lda VIC_SPRITE_X_EXTEND
	and #%00000001
	beq loadscreen_left
	rts

.maybe_right
	lda VIC_SPRITE_X_EXTEND
	and #%00000001
	bne loadscreen_right
	rts


;------------------------------------------------------------
; loadscreen_left / loadscreen_right
;------------------------------------------------------------
; Cambia indice schermata, ricostruisce mappa e ricolloca player.
loadscreen_left
	lda SCREEN_NR
	beq .skip_left
	
	dec SCREEN_NR
	jsr init_buildmap

	lda #38
	jsr RepositionPlayerOnScreenTransition
.skip_left
	rts


; Etichetta legacy usata da routine di bootstrap/debug.
debug1
loadscreen_right
	lda SCREEN_NR
	cmp #(MAP_LEN - 1)
	beq .skip_right
	
	inc SCREEN_NR
	jsr init_buildmap

	lda #1
	jsr RepositionPlayerOnScreenTransition
.skip_right
	rts


;------------------------------------------------------------
; RepositionPlayerOnScreenTransition
;------------------------------------------------------------
; Input:
;   A = nuova tile X del player (ingresso lato opposto)
; Effetti:
;   - mantiene la tile Y corrente
;   - inverte bit estensione X per coerenza VIC
;   - aggiorna coordinate sprite reali via routine centrale
RepositionPlayerOnScreenTransition
	sta PARAM1
	lda SPRITE_CHAR_POS_Y
	sta PARAM2
	ldx #0
	jsr ToggleSpriteXExtendForPlayer
	jsr CalcSpritePosFromCharPos
	rts


;------------------------------------------------------------
; ToggleSpriteXExtendForPlayer
;------------------------------------------------------------
; Toggle del bit 0 del registro X-extend sprite.
ToggleSpriteXExtendForPlayer
	lda VIC_SPRITE_X_EXTEND
	eor #%00000001
	sta VIC_SPRITE_X_EXTEND
	rts
