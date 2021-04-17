;------------------------------------------------------------
;check joystick (player control)   ; BREAK 0DAC
;------------------------------------------------------------
!zone PlayerControl
PlayerControl ; $0b2f

          lda PLAYER_JUMP_POS     	; lda $0f26
          bne .PlayerIsJumping ; 	; bne $0b78

          jsr PlayerMoveDown ;		; jsr $0cd0 	
          beq .NotFalling			; beq $0b36
          
          ;player fell one pixel
          jmp .PlayerFell			; jmp $0b45
          
          ;lda #$02
          ;bit $dc00
          ;bne .NotDownPressed
          ;jsr PlayerMoveDown
          
.NotFalling          
          lda #0				
          sta PLAYER_FALL_POS		; sta $0f31
          
.NotDownPressed          
          lda #$01					
          bit $dc00
          bne .ResetJump
		  lda UPRELEASED			; $0ebd
		  beq .NotUpPressed			; bne $0b69         
		  lda #0
		  sta UPRELEASED
          jsr .PlayerIsJumping		;jmp 0b7e
		  jmp .NotUpPressed
.ResetJump
		lda #01
		sta UPRELEASED
          
.PlayerFell
          ldx PLAYER_FALL_POS		; ldx 0f2b
          lda FALL_SPEED_TABLE,x	; lda 0f2c,x
          beq .FallComplete			; beq 0b5f
          sta PARAM5				; sta 07

.FallLoop          
          dec PARAM5				; dec 07
          beq .FallComplete			; beq 0b5f
          
          jsr PlayerMoveDown		; jsr 0cd6
          jmp .FallLoop				; jmp 0b55
          
.FallComplete
          lda PLAYER_FALL_POS		; lda 0f2b
          cmp #( FALL_TABLE_SIZE - 1 ) ; cmp #09
          beq .FallSpeedAtMax		; beq 0b69
          
          inc PLAYER_FALL_POS		; inc 02fb

.FallSpeedAtMax
.NotUpPressed          
.JumpStopped
.JumpComplete
          lda #$04					
          bit $dc00
          bne .NotLeftPressed		; bne 0b73
          jsr checkscreenscroll
		  jsr PlayerMoveLeft		; jsr 0bae
		  
          
.NotLeftPressed
          lda #$08	
          bit $dc00
          bne .NotRightPressed		; bne 0b7d
          jsr checkscreenscroll
		  jsr PlayerMoveRight		; jsr 0c11
		  

.NotRightPressed
          rts
		  


.PlayerIsJumping
          inc PLAYER_JUMP_POS
          lda PLAYER_JUMP_POS
          cmp #JUMP_TABLE_SIZE
          bne .JumpOn
          
          lda #0
          sta PLAYER_JUMP_POS
          jmp .JumpComplete
          
.JumpOn                    
          ldx PLAYER_JUMP_POS
          
          lda PLAYER_JUMP_TABLE,x
          beq .JumpComplete
          sta PARAM5
          
.JumpContinue          
          jsr PlayerMoveUp
          beq .JumpBlocked
          
          dec PARAM5
          bne .JumpContinue
          jmp .JumpComplete
          
          
.JumpBlocked
          lda #0
          sta PLAYER_JUMP_POS
          jmp .JumpStopped

;------------------------------------------------------------
;PlayerMoveLeft
;------------------------------------------------------------
!zone PlayerMoveLeft
PlayerMoveLeft
          ldx #0
          
          lda SPRITE_CHAR_POS_X_DELTA
          beq .CheckCanMoveLeft
          
.CanMoveLeft
          dec SPRITE_CHAR_POS_X_DELTA
		  dec SPRITE_CHAR_POS_X_DELTA
          
          jsr MoveSpriteLeft
          lda #1
          rts
          
.CheckCanMoveLeft
          lda SPRITE_CHAR_POS_Y_DELTA
          beq .NoThirdCharCheckNeeded
          
          ldy SPRITE_CHAR_POS_Y
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          lda SPRITE_CHAR_POS_X
          clc
          adc #39
          tay
          
          lda (ZEROPAGE_POINTER_1),y
          
          jsr IsCharBlocking
		  cmp #01
          beq .BlockedLeft
          
.NoThirdCharCheckNeeded          
          ldy SPRITE_CHAR_POS_Y
          dey
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_1 + 1
          
          ldy SPRITE_CHAR_POS_X
          dey
          
          lda (ZEROPAGE_POINTER_1),y
          
          jsr IsCharBlocking
          bne .BlockedLeft
          
          tya
          clc
          adc #40
          tay
          lda (ZEROPAGE_POINTER_1),y
          jsr IsCharBlocking
		  cmp #01
          beq .BlockedLeft
          
          
          lda #8
          sta SPRITE_CHAR_POS_X_DELTA
          dec SPRITE_CHAR_POS_X
          jmp .CanMoveLeft
          
.BlockedLeft
          lda #0
          rts

          
;------------------------------------------------------------
;PlayerMoveRight
;------------------------------------------------------------
!zone PlayerMoveRight
PlayerMoveRight
          ldx #0
          
          lda SPRITE_CHAR_POS_X_DELTA
          beq .CheckCanMoveRight
          
.CanMoveRight
          inc SPRITE_CHAR_POS_X_DELTA 	; inc $0f47
		  inc SPRITE_CHAR_POS_X_DELTA 	; inc $0f47
          
          lda SPRITE_CHAR_POS_X_DELTA 	; lda 0f47
          cmp #8
          bne .NoCharStep				; bne 0c2a
          
          lda #0
          sta SPRITE_CHAR_POS_X_DELTA
          inc SPRITE_CHAR_POS_X
          
.NoCharStep          
          jsr MoveSpriteRight			; jsr 0d56
          lda #1
          rts
          
.CheckCanMoveRight
          lda SPRITE_CHAR_POS_Y_DELTA
          beq .NoThirdCharCheckNeeded
          
          ldy SPRITE_CHAR_POS_Y
          iny
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ldy SPRITE_CHAR_POS_X
          iny
          
          lda (ZEROPAGE_POINTER_1),y
          
          jsr IsCharBlocking
		  cmp #01
          beq .BlockedRight
          
.NoThirdCharCheckNeeded          

          ldy SPRITE_CHAR_POS_Y					; ldy $0f4f
          dey
          lda SCREEN_LINE_OFFSET_TABLE_LO,y		; $a8
          sta ZEROPAGE_POINTER_1				; $17 = $a8
          lda SCREEN_LINE_OFFSET_TABLE_HI,y		; $ce
          sta ZEROPAGE_POINTER_1 + 1			; $18 = $ce
          
          ldy SPRITE_CHAR_POS_X					; ldy $0f3f
          iny
          lda (ZEROPAGE_POINTER_1),y			; a = $04
          
          jsr IsCharBlocking					; jsr $0d96
          bne .BlockedRight
          
          tya
          clc
          adc #40
          tay
          lda (ZEROPAGE_POINTER_1),y
          jsr IsCharBlocking
		  cmp #01
          beq .BlockedRight
          
          jmp .CanMoveRight 				; jmp 0c18
          
.BlockedRight 
          lda #0
          rts
          

;------------------------------------------------------------
;PlayerMoveUp
;------------------------------------------------------------
!zone PlayerMoveUp
PlayerMoveUp
          ldx #0
          
          lda SPRITE_CHAR_POS_Y_DELTA
          beq .CheckCanMoveUp
          
.CanMoveUp
          dec SPRITE_CHAR_POS_Y_DELTA
          
          lda SPRITE_CHAR_POS_Y_DELTA
          cmp #$ff
          bne .NoCharStep
          
          dec SPRITE_CHAR_POS_Y
          lda #7
          sta SPRITE_CHAR_POS_Y_DELTA
          
.NoCharStep          
          jsr MoveSpriteUp
          lda #1
          rts
          
.CheckCanMoveUp
          lda SPRITE_CHAR_POS_X_DELTA
          beq .NoSecondCharCheckNeeded
          
          ldy SPRITE_CHAR_POS_Y
          dey
          dey
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ldy SPRITE_CHAR_POS_X
          iny
          
          lda (ZEROPAGE_POINTER_1),y
          
          jsr IsCharBlocking
		  cmp #01
          beq .BlockedUp
          
.NoSecondCharCheckNeeded          

          ldy SPRITE_CHAR_POS_Y
          dey
          dey
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_1 + 1
          
          ldy SPRITE_CHAR_POS_X
          
          lda (ZEROPAGE_POINTER_1),y
          
          jsr IsCharBlocking
		  cmp #01
          beq .BlockedUp
          
          jmp .CanMoveUp
          
.BlockedUp
          lda #0
          rts
          
          
;------------------------------------------------------------
;PlayerMoveDown
;------------------------------------------------------------
!zone PlayerMoveDown
PlayerMoveDown 							; $0cd0
          ldx #0
          
          lda SPRITE_CHAR_POS_Y_DELTA 	; LDA $0f5d
          beq .CheckCanMoveDown 		; BEQ $0cef
          
.CanMoveDown
          inc SPRITE_CHAR_POS_Y_DELTA	; inc $0f5d
          
          lda SPRITE_CHAR_POS_Y_DELTA	; LDA $0f5d
          cmp #8
          bne .NoCharStep				; bne $0ce9
          
          lda #0
          sta SPRITE_CHAR_POS_Y_DELTA	; lda 0f5d
          inc SPRITE_CHAR_POS_Y			; inc 0f55
          
.NoCharStep          
          jsr MoveSpriteDown			; jsr 0d83
          lda #1
          rts
          
.CheckCanMoveDown ; 0cef
          lda SPRITE_CHAR_POS_X_DELTA    		;LDA $0f4d
          beq .NoSecondCharCheckNeeded			; BEQ $0d0d
          
          ldy SPRITE_CHAR_POS_Y
          iny
          lda SCREEN_LINE_OFFSET_TABLE_LO,y
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y
          sta ZEROPAGE_POINTER_1 + 1

          ldy SPRITE_CHAR_POS_X
          iny
          lda (ZEROPAGE_POINTER_1),y
          
          jsr IsCharBlockingFall ; $0Da6 <---- !
		  cmp #01
          beq .BlockedDown 
          
.NoSecondCharCheckNeeded          ; 0d28

          ldy SPRITE_CHAR_POS_Y					; LDY $0f55
          iny									; Y=$4d
          lda SCREEN_LINE_OFFSET_TABLE_LO,y		; LDA $0D1D,y (A=$C8)
          sta ZEROPAGE_POINTER_1
          lda SCREEN_LINE_OFFSET_TABLE_HI,y		; LDA $0D36,y (A=$CC)
          sta ZEROPAGE_POINTER_1 + 1			; ZEROPAGE_POINTER_1 = $CCC8 (Quinta Riga di caratteri dall'alto)
          
          ldy SPRITE_CHAR_POS_X					; LDA $0f45 (X=00)
          
          lda (ZEROPAGE_POINTER_1),y			; LDA ($17),Y A=$60
												; A contiene il carattere 
												; sotto lo sprite
          
          jsr IsCharBlockingFall				; JSR $0da6	
		  cmp #01
          beq .BlockedDown
          
          jmp .CanMoveDown
          
.BlockedDown
          lda #0
          rts
          

;------------------------------------------------------------
;Move Sprite Left
;expect x as sprite index (0 to 7)
;------------------------------------------------------------
!zone MoveSpriteLeft
MoveSpriteLeft
          dec SPRITE_POS_X,x
		  dec SPRITE_POS_X,x
          bpl .NoChangeInExtendedFlag
          
          ; lda BIT_TABLE,x
          ; eor #$ff
          ; and SPRITE_POS_X_EXTEND
          ; sta SPRITE_POS_X_EXTEND
          ; sta VIC_SPRITE_X_EXTEND
          
		  lda BIT_TABLE,x
          eor #$ff
          and SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
		  lda BIT_TABLE+1,x
          eor #$ff
		  and SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
          sta VIC_SPRITE_X_EXTEND
		  
.NoChangeInExtendedFlag     
          txa
          asl
          tay
          
          lda SPRITE_POS_X,x
          sta VIC_SPRITE_X_POS,y
		  sta VIC_SPRITE_X_POS+2,y
		  ldy #1
		  sty PLY1_DIR
		  jsr ply1Animate
          rts  

;------------------------------------------------------------
;Move Sprite Right
;expect x as sprite index (0 to 7)
;------------------------------------------------------------
!zone MoveSpriteRight
MoveSpriteRight
          inc SPRITE_POS_X,x			; inc 0f36,x
		  inc SPRITE_POS_X,x
          lda SPRITE_POS_X,x			;
          bne .NoChangeInExtendedFlag
          
          ;lda BIT_TABLE,x
          ;ora SPRITE_POS_X_EXTEND
          ;sta SPRITE_POS_X_EXTEND
          ;sta VIC_SPRITE_X_EXTEND
		  
		  lda BIT_TABLE,x
          ora SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
		  lda BIT_TABLE+1,x
		  ora SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
          sta VIC_SPRITE_X_EXTEND
		  
          
.NoChangeInExtendedFlag     
          txa
          asl
          tay
          
          lda SPRITE_POS_X,x
          sta VIC_SPRITE_X_POS,y
		  sta VIC_SPRITE_X_POS+2,y
		  ldy #2
		  sty PLY1_DIR
		  jsr ply1Animate
          rts  

;------------------------------------------------------------
;Move Sprite Up
;expect x as sprite index (0 to 7)
;------------------------------------------------------------
!zone MoveSpriteUp
MoveSpriteUp
          dec SPRITE_POS_Y,x
          
          txa
          asl
          tay
          
          lda SPRITE_POS_Y,x
          sta VIC_SPRITE_Y_POS,y
		  sta VIC_SPRITE_Y_POS+2,y
          rts  

;------------------------------------------------------------
;Move Sprite Down
;expect x as sprite index (0 to 7)
;------------------------------------------------------------
!zone MoveSpriteDown
MoveSpriteDown
          inc SPRITE_POS_Y,x
          
          txa
          asl
          tay
          
          lda SPRITE_POS_Y,x
          sta VIC_SPRITE_Y_POS,y
		  sta VIC_SPRITE_Y_POS+2,y
          rts  


;------------------------------------------------------------
;IsCharBlocking
;checks if a char is blocking
;PARAM1 = char_pos_x
;PARAM2 = char_pos_y
;returns 1 for blocking, 0 for not blocking
;------------------------------------------------------------
!zone IsCharBlocking
IsCharBlocking
          ; cmp #128
		  ; bpl .Blocking
		  
		  stx $fe
		  tax
		  lda ADDR_CHARSET_ATTRIB_DATA,x		; 0f78,04
		  and #$f0
		  cmp #$F0
		  beq .Blocking
		  
          
          
          lda #0
		  ldx $fe
          rts
          
.Blocking
          lda #1
		  ldx $fe
          rts


;------------------------------------------------------------
;IsCharBlockingFall
;checks if a char is blocking a fall (downwards)
;PARAM1 = char_pos_x
;PARAM2 = char_pos_y
;returns 1 for blocking, 0 for not blocking
;------------------------------------------------------------
!zone IsCharBlockingFall ; 0da6
IsCharBlockingFall
          ; cmp #9
		  ; beq .Blocking          
		  	
		  stx $fe
		  tax
		  lda ADDR_CHARSET_ATTRIB_DATA,x
		  and #$f0
		  cmp #$F0
		  beq .Blocking
		  
          
          lda #0
		  ldx $fe
          rts
          
.Blocking
          lda #1
		  ldx $fe
          rts


;------------------------------------------------------------
;CalcSpritePosFromCharPos
;calculates the real sprite coordinates from screen char pos
;PARAM1 = char_pos_x
;PARAM2 = char_pos_y
;X      = sprite index
;------------------------------------------------------------
!zone CalcSpritePosFromCharPos    
CalcSpritePosFromCharPos

          ;offset screen to border 24,50
          lda BIT_TABLE,x
          eor #$ff
          and SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
		  lda BIT_TABLE+1,x
          eor #$ff
          and SPRITE_POS_X_EXTEND
          sta VIC_SPRITE_X_EXTEND
          
          ;need extended x bit?
          lda PARAM1
          sta SPRITE_CHAR_POS_X,x
          cmp #30
          bcc .NoXBit
          
          lda BIT_TABLE,x
          ora SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
		  lda BIT_TABLE+1,x
		  ora SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
          sta VIC_SPRITE_X_EXTEND
          
.NoXBit   
          ;calculate sprite positions (offset from border)
          txa
          asl
          tay
          
          lda PARAM1
          asl
          asl
          asl
          clc
          adc #( 24 - SPRITE_CENTER_OFFSET_X )
          sta SPRITE_POS_X,x
          sta VIC_SPRITE_X_POS,y
		  sta VIC_SPRITE_X_POS+2,y
          
          lda PARAM2
          sta SPRITE_CHAR_POS_Y,x
          asl
          asl
          asl
          clc
          adc #( 50 - SPRITE_CENTER_OFFSET_Y )
          sta SPRITE_POS_Y,x
          sta VIC_SPRITE_Y_POS,y
		  sta VIC_SPRITE_Y_POS+2,y
          
          lda #0
          sta SPRITE_CHAR_POS_X_DELTA,x
          sta SPRITE_CHAR_POS_Y_DELTA,x
          rts

!Zone Player1Animation
ply1Animate
		lda PLY1_ANMT_DLY
		dec PLY1_ANMT_DLY
		beq ply1nextFrame
		rts
ply1nextFrame
		lda #5
		sta PLY1_ANMT_DLY
		ldx PLY1_ANMT_CURFRAME
		cpx #PLY1_ANMT_MVRGT_SIZE
		beq pl1ResetFrameCount
		lda PLY1_DIR
		cmp #1
		bne NoLeft
		jsr pl1AnimateLeft
NoLeft
		cmp #2
		bne NoRight
		jsr pl1AnimateRight
NoRight
		rts
pl1AnimateLeft
		;ldx PLY1_ANMT_CURFRAME
		lda PLY1_ANMT_MVLFT,x
		sta SPRITE_POINTER_BASE+1
		clc
		adc #01
		sta SPRITE_POINTER_BASE
		inx
		stx PLY1_ANMT_CURFRAME
		rts
pl1AnimateRight
		;ldx PLY1_ANMT_CURFRAME
		lda PLY1_ANMT_MVRGT,x
		sta SPRITE_POINTER_BASE+1
		clc
		adc #01
		sta SPRITE_POINTER_BASE
		inx
		stx PLY1_ANMT_CURFRAME
		rts
pl1ResetFrameCount
		lda #0
		sta PLY1_ANMT_CURFRAME
		rts
		

