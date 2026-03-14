; routine assemblata su $0924

!Zone BuildMap
init_buildmap:	
	; Points our ZP 16 bit pointer to map data address ($0FDA)
	;lda #<ADDR_MAP_DATA
	ldx SCREEN_NR	
;	beq .NotDoubleIndex
;.NotDoubleIndex
	lda ADDR_MAP_DATA_TABLE_HI,X
	;lda #<MAP_SCR3 
	sta ZEROPAGE_POINTER_1
	;lda #>ADDR_MAP_DATA
	lda ADDR_MAP_DATA_TABLE_LO,x
	;lda #>MAP_SCR3
	sta ZEROPAGE_POINTER_1+1
	
	; Points our ZP 16 bit pointer to tile data address 
	; lda #<ADDR_TILESET_DATA
	; sta ZEROPAGE_POINTER_2
	; lda #>ADDR_TILESET_DATA
	; sta ZEROPAGE_POINTER_2+1
	
	; Points our ZP 16 bit pointer to attribs data address 
	; lda #<ADDR_CHARSET_ATTRIB_DATA
	; sta ZEROPAGE_POINTER_3
	; lda #>ADDR_CHARSET_ATTRIB_DATA
	; sta ZEROPAGE_POINTER_3+1
	
	lda #0					;set colours
	sta $d020
	lda #COLR_SCREEN
	sta $d021
	lda #COLR_CHAR_MC1
	sta $d022
	lda #COLR_CHAR_MC2
	sta $d023
; $093D	
decodemap:
	lda #0
	sta MAPCOUNTER ; MAPCOUNTER = $09AC

cyclemap:
	ldy MAPCOUNTER
	lda (ZEROPAGE_POINTER_1),y
	; calculate lo-byte tile address 
	; (masking the lsb and multiplicating them by 16)
	and #$0f
	asl
	asl
	asl
	asl
	sta ZEROPAGE_POINTER_2	 ; for Y = 0 index tile n. $11 = Low byte tile address = $10
	lda (ZEROPAGE_POINTER_1),y
	; calculate hi-byte tile address 
	; (masking the msb and multiplicating them by 16)
	and #$f0
	lsr
	lsr
	lsr
	lsr
	; for Y = 0 index tile n. $11 = High byte tile address = $01
	
	clc
	adc #>ADDR_TILESET_DATA
	
	; adding the lowbyte of ADDR_TILESET_DATA for getting the page index - High byte tile address = $01
	sta ZEROPAGE_POINTER_2+1 ; 
	; Now ZEROPAGE_POINTER_2 points to our tile
	
	; initialize tilecounter
	lda #0
	sta TILECOUNTER ; $0a62
	 
	; points ZP_PT3 to screenram position for this tile of 
	; the map and ZP_PT4 to colram position for this tile 
	; of the map
	lda SCREEN_TILE_OFFSET_TABLE_LO,y
	sta ZEROPAGE_POINTER_3
	sta ZEROPAGE_POINTER_4
	lda SCREEN_TILE_OFFSET_TABLE_HI,y
	sta ZEROPAGE_POINTER_3+1
	clc
	adc #( ( SCREEN_COLOR - SCREEN_CHAR ) & 0xff00 ) >> 8
	sta ZEROPAGE_POINTER_4 + 1
	
;I initialize char counter	
	ldx #0
	stx CHARCOUNTER	
cycletile:	
	; load the charcode from tile data address
	ldy TILECOUNTER	
	lda (ZEROPAGE_POINTER_2),y	
	; store character in screenram
	ldy CHARCOUNTER	
	sta (ZEROPAGE_POINTER_3),y
	
	; load attribute from attr data address
	tay	
	lda ADDR_CHARSET_ATTRIB_DATA,y
	and #$0f
	; store color in colram	
	ldy CHARCOUNTER
	sta (ZEROPAGE_POINTER_4),y
	; Increments the character counter
	iny
	sty CHARCOUNTER
	; increments the row counter
	ldx CHARROWCOUNT
	inx
	stx CHARROWCOUNT
	; if we're at fourth char, let's move to next row
	cpx #4
	beq resetfourthcount
	; otherwise let's continue with the current row
continuecycle
	ldx TILECOUNTER
	inx
	stx TILECOUNTER
	cpx #16
	bne cycletile
; if we didn't reached the 16th char, we can continue with the current tile, otherwise we can skip to next one
	ldx MAPCOUNTER
	inx
	stx MAPCOUNTER	
	cpx #50
	bne cyclemap
	rts

resetfourthcount
	lda CHARCOUNTER
	clc
	adc #36
	sta CHARCOUNTER
	bcc noincscreenhibyte
	ldx ZEROPAGE_POINTER_3+1
	inx
	stx ZEROPAGE_POINTER_3+1
	ldx ZEROPAGE_POINTER_4+1
	inx 
	stx ZEROPAGE_POINTER_4+1
	
; otherwise continue regurarly
noincscreenhibyte	
	lda #0
	sta CHARROWCOUNT
	jmp continuecycle
	
MAPCOUNTER
	!byte 0
TILECOUNTER
	!byte 0
CHARCOUNTER
	!byte 0
CHARROWCOUNT
	!byte 0
	
clearbottom:
	ldx #0
	lda #$04
loopclear	
	sta $CF20,x
	inx
	cpx #200
	bne loopclear	
	rts
	