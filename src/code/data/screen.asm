;------------------------------------------------------------
;screen levels data
;------------------------------------------------------------

LEVEL_NR  
          !byte 0

;level data constants
LD_END                  = 0
LD_LINE_H               = 1
LD_LINE_V               = 2


SCREEN_DATA_TABLE
          !word LEVEL_1
          !word 0
          
; Level Data Scheme: TYPE,XPos,YPos,Width,Char,Color
		  
LEVEL_1
          !byte LD_LINE_H,5,5,10,96,13
          !byte LD_LINE_H,12,7,8,96,13
          !byte LD_LINE_H,30,12,9,97,13
          !byte LD_LINE_H,10,19,20,96,13
          !byte LD_LINE_V,7,6,4,128,9
          !byte LD_END


LEVEL_BORDER_DATA
          !byte LD_LINE_H,0,0,40,128,9
          !byte LD_LINE_H,1,22,38,129,9
          !byte LD_LINE_V,0,1,22,128,9
          !byte LD_LINE_V,39,1,22,129,9
          !byte LD_END

SCREEN_LINE_OFFSET_TABLE_LO
          !byte ( SCREEN_CHAR +   0 ) & 0x00ff ; ($cc00 + 0 )  = $cc00 AND $ff = $0
          !byte ( SCREEN_CHAR +  40 ) & 0x00ff ; ($cc00 + 40)  = $cc28 AND $ff = $28
          !byte ( SCREEN_CHAR +  80 ) & 0x00ff ; ($cc00 + 80)  = $cc50 AND $ff = $50
          !byte ( SCREEN_CHAR + 120 ) & 0x00ff ; ($cc00 + 120) = $cc78 AND $ff = $78
          !byte ( SCREEN_CHAR + 160 ) & 0x00ff
          !byte ( SCREEN_CHAR + 200 ) & 0x00ff ; ($cc00 + 200) = $ccc8 AND $ff = $c8
          !byte ( SCREEN_CHAR + 240 ) & 0x00ff
          !byte ( SCREEN_CHAR + 280 ) & 0x00ff
          !byte ( SCREEN_CHAR + 320 ) & 0x00ff
          !byte ( SCREEN_CHAR + 360 ) & 0x00ff
          !byte ( SCREEN_CHAR + 400 ) & 0x00ff
          !byte ( SCREEN_CHAR + 440 ) & 0x00ff
          !byte ( SCREEN_CHAR + 480 ) & 0x00ff
          !byte ( SCREEN_CHAR + 520 ) & 0x00ff
          !byte ( SCREEN_CHAR + 560 ) & 0x00ff
          !byte ( SCREEN_CHAR + 600 ) & 0x00ff
          !byte ( SCREEN_CHAR + 640 ) & 0x00ff
          !byte ( SCREEN_CHAR + 680 ) & 0x00ff
          !byte ( SCREEN_CHAR + 720 ) & 0x00ff
          !byte ( SCREEN_CHAR + 760 ) & 0x00ff
          !byte ( SCREEN_CHAR + 800 ) & 0x00ff
          !byte ( SCREEN_CHAR + 840 ) & 0x00ff
          !byte ( SCREEN_CHAR + 880 ) & 0x00ff
          !byte ( SCREEN_CHAR + 920 ) & 0x00ff
          !byte ( SCREEN_CHAR + 960 ) & 0x00ff
SCREEN_LINE_OFFSET_TABLE_HI
          !byte ( ( SCREEN_CHAR +   0 ) & 0xff00 ) >> 8 
          !byte ( ( SCREEN_CHAR +  40 ) & 0xff00 ) >> 8 ; $cc00 + $28 = $CC48 & $FF00 = $CC00 RSL 8 = $CC
          !byte ( ( SCREEN_CHAR +  80 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 120 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 160 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 200 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 240 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 280 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 320 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 360 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 400 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 440 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 480 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 520 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 560 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 600 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 640 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 680 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 720 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 760 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 800 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 840 ) & 0xff00 ) >> 8 ; $cc00 + $348 = $CF48 & $FF00 = $CF00 RSL 8 = $CF
          !byte ( ( SCREEN_CHAR + 880 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 920 ) & 0xff00 ) >> 8
          !byte ( ( SCREEN_CHAR + 960 ) & 0xff00 ) >> 8
		  
SCREEN_TILE_OFFSET_TABLE_LO
; RIGA 0
	!byte ( SCREEN_CHAR +   0 ) & 0x00ff
	!byte ( SCREEN_CHAR +   4 ) & 0x00ff
	!byte ( SCREEN_CHAR +   8 ) & 0x00ff
	!byte ( SCREEN_CHAR +  12 ) & 0x00ff
	!byte ( SCREEN_CHAR +  16 ) & 0x00ff
	!byte ( SCREEN_CHAR +  20 ) & 0x00ff
	!byte ( SCREEN_CHAR +  24 ) & 0x00ff
	!byte ( SCREEN_CHAR +  28 ) & 0x00ff
	!byte ( SCREEN_CHAR +  32 ) & 0x00ff
	!byte ( SCREEN_CHAR +  36 ) & 0x00ff
; RIGA 4	
	!byte ( SCREEN_CHAR + 160 ) & 0x00ff
	!byte ( SCREEN_CHAR + 164 ) & 0x00ff
	!byte ( SCREEN_CHAR + 168 ) & 0x00ff
	!byte ( SCREEN_CHAR + 172 ) & 0x00ff
	!byte ( SCREEN_CHAR + 176 ) & 0x00ff
	!byte ( SCREEN_CHAR + 180 ) & 0x00ff
	!byte ( SCREEN_CHAR + 184 ) & 0x00ff
	!byte ( SCREEN_CHAR + 188 ) & 0x00ff
	!byte ( SCREEN_CHAR + 192 ) & 0x00ff
	!byte ( SCREEN_CHAR + 196 ) & 0x00ff
; RIGA 8
	!byte ( SCREEN_CHAR + 320 ) & 0x00ff
	!byte ( SCREEN_CHAR + 324 ) & 0x00ff
	!byte ( SCREEN_CHAR + 328 ) & 0x00ff
	!byte ( SCREEN_CHAR + 332 ) & 0x00ff
	!byte ( SCREEN_CHAR + 336 ) & 0x00ff
	!byte ( SCREEN_CHAR + 340 ) & 0x00ff
	!byte ( SCREEN_CHAR + 344 ) & 0x00ff
	!byte ( SCREEN_CHAR + 348 ) & 0x00ff
	!byte ( SCREEN_CHAR + 352 ) & 0x00ff
	!byte ( SCREEN_CHAR + 356 ) & 0x00ff
; RIGA 16
	!byte ( SCREEN_CHAR + 480 ) & 0x00ff
	!byte ( SCREEN_CHAR + 484 ) & 0x00ff
	!byte ( SCREEN_CHAR + 488 ) & 0x00ff
	!byte ( SCREEN_CHAR + 492 ) & 0x00ff
	!byte ( SCREEN_CHAR + 496 ) & 0x00ff
	!byte ( SCREEN_CHAR + 500 ) & 0x00ff
	!byte ( SCREEN_CHAR + 504 ) & 0x00ff
	!byte ( SCREEN_CHAR + 508 ) & 0x00ff
	!byte ( SCREEN_CHAR + 512 ) & 0x00ff
	!byte ( SCREEN_CHAR + 516 ) & 0x00ff
; RIGA 20
	!byte ( SCREEN_CHAR + 640 ) & 0x00ff
	!byte ( SCREEN_CHAR + 644 ) & 0x00ff
	!byte ( SCREEN_CHAR + 648 ) & 0x00ff
	!byte ( SCREEN_CHAR + 652 ) & 0x00ff
	!byte ( SCREEN_CHAR + 656 ) & 0x00ff
	!byte ( SCREEN_CHAR + 660 ) & 0x00ff
	!byte ( SCREEN_CHAR + 664 ) & 0x00ff
	!byte ( SCREEN_CHAR + 668 ) & 0x00ff
	!byte ( SCREEN_CHAR + 672 ) & 0x00ff
	!byte ( SCREEN_CHAR + 676 ) & 0x00ff
	
SCREEN_TILE_OFFSET_TABLE_HI
; RIGA 0
	!byte ( ( SCREEN_CHAR +   0 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +   4 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +   8 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  12 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  16 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  20 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  24 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  28 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  32 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR +  36 ) & 0xff00 ) >> 8
; RIGA 4
	!byte ( ( SCREEN_CHAR + 160 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 164 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 168 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 172 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 176 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 180 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 184 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 188 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 192 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 196 ) & 0xff00 ) >> 8
; RIGA 8
	!byte ( ( SCREEN_CHAR + 320 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 324 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 328 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 332 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 336 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 340 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 344 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 348 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 352 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 356 ) & 0xff00 ) >> 8
; RIGA 16
	!byte ( ( SCREEN_CHAR + 480 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 484 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 488 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 492 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 496 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 500 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 504 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 508 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 512 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 516 ) & 0xff00 ) >> 8
; RIGA 20
	!byte ( ( SCREEN_CHAR + 640 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 644 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 648 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 652 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 656 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 660 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 664 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 668 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 672 ) & 0xff00 ) >> 8
	!byte ( ( SCREEN_CHAR + 676 ) & 0xff00 ) >> 8
