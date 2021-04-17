checkplayerposition
	lda VIC_SPRITE_Y_POS
	cmp #200
	bcc exitcheck
	lda #0
	sta VIC_SPRITE_X_EXTEND
init_player
	;init sprite 1 pos
	lda #5
	sta PARAM1
	lda #5
	sta PARAM2
	ldx #0

	jsr CalcSpritePosFromCharPos

exitcheck
check_keyboard
	lda #%11111111  ; CIA#1 Port A set to output 
	sta CIA1_DDRA             
	lda #%00000000  ; CIA#1 Port B set to inputt
	sta CIA1_DDRB             

check_space             
	lda #%01111111  ; select row 8
	sta CIA1_PRA 
	lda CIA1_PRB         ; load column information
	and #%00010000  ; test 'space' key to exit 
	beq init_player

check_d                 
	lda #%11111011  ; select row 3
	sta CIA1_PRA 
	lda CIA1_PRB         ; load column information
	and #%00000100  ; test 'd' key  
	beq move_leftscreen

check_u
	lda #%11110111  ; select row 4
	sta CIA1_PRA 
	lda CIA1_PRB         ; load column information
	and #%01000000  ; test 'u' key 
	beq move_rightscreen	
	rts             ; return    


	; lda VIC_SPRITE_X_POS
	; cmp #$0d
	; beq checkxextend_left
	; cmp #$4a
	; beq checkxextend_right
	; rts
	
; checkxextend_left
	; lda VIC_SPRITE_X_EXTEND
	; beq loadscreen_left
	; rts
; checkxextend_right
	; lda VIC_SPRITE_X_EXTEND
	; bne loadscreen_right
	; rts
	
; loadscreen_left
	; lda SCREEN_NR
	; cmp #00
	; bne move_leftscreen
	; rts
move_leftscreen
	;jsr disable_irq
	ldx SCREEN_NR
	dex
	stx SCREEN_NR
	txa
	asl 
	sta SCREEN_PTR
	jsr init_buildmap
	jsr clearbottom
	;jsr setup_irq
	; lda #40
	; sta PARAM1
	; lda SPRITE_CHAR_POS_Y
	; sta PARAM2
	; ldx #0
	; jsr CalcSpritePosFromCharPos	
	
	

; loadscreen_right
	; lda SCREEN_NR
	; ;lda 	$0fae
	; cmp #MAP_LEN
	; bne move_rightscreen
	; rts
move_rightscreen
debug1
	;jsr disable_irq ; $095E
	 ; $0AEB
	ldx SCREEN_NR ; $0FD4
	inx
	stx SCREEN_NR
	txa
	asl 
	sta SCREEN_PTR ; $0FD3
	jsr init_buildmap ; $09C7
	jsr clearbottom ; $0A7E
	; ; jsr $09ab
	; lda #40
	; sta PARAM1
	; lda SPRITE_CHAR_POS_Y
	; sta PARAM2
	; ldx #0
	; jsr CalcSpritePosFromCharPos
	jsr setup_irq