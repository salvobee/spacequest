;------------------------------------------------------------
;check joystick (player control)
;------------------------------------------------------------
!zone PlayerControl
PlayerControl
          lda #$2
          bit $dc00
          bne .NotDownPressed
          jsr PlayerMoveDown
          
.NotDownPressed 
          lda #$1
          bit $dc00
          bne .NotUpPressed
          jsr PlayerMoveUp
          
.NotUpPressed
          lda #$4
          bit $dc00
          bne .NotLeftPressed
          jsr PlayerMoveLeft
          
.NotLeftPressed
          lda #$8
          bit $dc00
          bne .NotRightPressed
          jsr PlayerMoveRight
          
.NotRightPressed
          rts
          
PlayerMoveLeft
          ldx #0
          jsr MoveSpriteLeft
          rts
          
PlayerMoveRight
          ldx #0
          jsr MoveSpriteRight
          rts
          
PlayerMoveUp
          ldx #0
          jsr MoveSpriteUp
          rts
          
PlayerMoveDown
          ldx #0
          jsr MoveSpriteDown
          rts
		  
          ;------------------------------------------------------------
          ;Move Sprite Left
          ;expect x as sprite index (0 to 7)
          ;------------------------------------------------------------
!zone MoveSpriteLeft
MoveSpriteLeft
          dec SPRITE_POS_X,x
          bpl .NoChangeInExtendedFlag
          lda BIT_TABLE,x
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
          rts
          
          ;------------------------------------------------------------
          ;Move Sprite Right
          ;expect x as sprite index (0 to 7)
          ;------------------------------------------------------------
!zone MoveSpriteRight
MoveSpriteRight
          inc SPRITE_POS_X,x
          lda SPRITE_POS_X,x
          bne .NoChangeInExtendedFlag
          lda BIT_TABLE,x
          ora SPRITE_POS_X_EXTEND
          sta SPRITE_POS_X_EXTEND
          sta VIC_SPRITE_X_EXTEND
.NoChangeInExtendedFlag
          txa
          asl
          tay
          lda SPRITE_POS_X,x
          sta VIC_SPRITE_X_POS,y
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
          rts