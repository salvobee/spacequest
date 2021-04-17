setup_init
           ;init sprite registers
          ;no visible sprites
          lda #0
          sta VIC_SPRITE_ENABLE
          
          ;set charset
          lda #$3c
          sta VIC_MEMORY_CONTROL

          ;VIC bank
          lda CIA2_PRA
          and #$fc
          sta CIA2_PRA

          ;----------------------------------
          ;copy charset and sprites to target          
          ;----------------------------------
          
          ;block interrupts 
          ;since we turn ROMs off this would result in crashes if we didn't
          sei
          
          ;save old configuration
          lda $01
          sta PARAM1
          
          ;only RAM
          ;to copy under the IO rom
          lda #%00110000
          sta $01
          
          ;take source address from CHARSET
          ;LDA #<CHARSET
		  LDA #<ADDR_CHARSET_DATA
          STA ZEROPAGE_POINTER_1
          ;LDA #>CHARSET
		  LDA #>ADDR_CHARSET_DATA
          STA ZEROPAGE_POINTER_1 + 1
          
          ;now copy
          jsr CopyCharSet 
          
          ;take source address from SPRITES
          lda #<SPRITES
          sta ZEROPAGE_POINTER_1
          lda #>SPRITES
          sta ZEROPAGE_POINTER_1 + 1
          
          jsr CopySprites ; jsr $0907
          
          ;restore ROMs
          lda PARAM1
          sta $01
          
          cli
          
          ;background black
          lda #0
          sta VIC_BACKGROUND_COLOR
          
          ;set charset multi colors
          lda #12
          sta VIC_CHARSET_MULTICOLOR_1
          lda #8
          sta VIC_CHARSET_MULTICOLOR_2
          ;enable multi color charset
          lda VIC_CONTROL
          ora #$10
          sta VIC_CONTROL
          
          ;setup level
          lda #0
          sta SCREEN_NR
          ;jsr BuildScreen
		  jsr init_buildmap
		  jsr clearbottom
 
resetplayerpos 
          ;set sprite flags
          lda #0
          sta VIC_SPRITE_X_EXTEND
          
		  ;init sprite 1 pos
          lda #5
          sta PARAM1
          lda #5
          sta PARAM2
          ldx #0
          
          jsr CalcSpritePosFromCharPos
          
          lda #100
          ;sta VIC_SPRITE_X_POS
          ;sta VIC_SPRITE_Y_POS
          ;sta SPRITE_POS_X
          ;sta SPRITE_POS_Y
          
          ;set sprite image
		  lda #65
          sta SPRITE_POINTER_BASE
          lda #64
          sta SPRITE_POINTER_BASE+1
		  
		  
		  ;set sprite colors
		  lda #01
		  sta VIC_SPRITE_MULTICOLOR_1
		  lda #00
		  sta VIC_SPRITE_MULTICOLOR_2
		  lda #15
		  sta VIC_SPRITE1_COLOR
		  lda #05
		  sta VIC_SPRITE2_COLOR
		  
		  ;setup multicolor sprites
		  lda #%01010110
		  sta VIC_SPRITE_MULTICOLOR
          
          ;enable sprite 1 and 2
          lda #%00000011
          sta VIC_SPRITE_ENABLE
          
		  rts