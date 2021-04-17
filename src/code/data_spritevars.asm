;address of sprite pointers
SPRITE_POINTER_BASE     = SCREEN_CHAR + 1016

;number of sprites divided by four
NUMBER_OF_SPRITES_DIV_4 = 32

;sprite number constant
SPRITE_BASE             = 64

SPRITE_PLAYER           = SPRITE_BASE + 0

;offset from calculated char pos to true sprite pos
SPRITE_CENTER_OFFSET_X  = 8
SPRITE_CENTER_OFFSET_Y  = 13

;entries of jump table
JUMP_TABLE_SIZE         = 10

;entries of fall table
FALL_TABLE_SIZE         = 10

UPRELEASED !byte 01

PLAYER_JUMP_POS
          !byte 0
PLAYER_JUMP_TABLE
	   !byte 8,8,8,8,8,4,2,1,0,0
        ;  !byte 24,23,5,3,2,1,1,1,0,0
          
PLAYER_FALL_POS
          !byte 0
FALL_SPEED_TABLE
          !byte 1,1,2,2,3,3,3,3,3,3
          
          
SPRITE_POS_X
          !byte 0,0,0,0,0,0,0,0
SPRITE_POS_X_EXTEND
          !byte 0
SPRITE_CHAR_POS_X
          !byte 0,0,0,0,0,0,0,0
SPRITE_CHAR_POS_X_DELTA ; $0f4d
          !byte 0,0,0,0,0,0,0,0
SPRITE_CHAR_POS_Y
          !byte 0,0,0,0,0,0,0,0
SPRITE_CHAR_POS_Y_DELTA  ; $0f5d
          !byte 0,0,0,0,0,0,0,0
SPRITE_POS_Y
          !byte 0,0,0,0,0,0,0,0
BIT_TABLE
          !byte 1,2,4,8,16,32,64,128
		  
		  
PLY1_ANMT_CURFRAME
			!byte 0

PLY1_DIR
		!byte 0
			
PLY1_ANMT_DLY
		!byte 4

PLY1_ANMT_MVRGT_SIZE = 8
PLY1_ANMT_MVRGT
		;!byte 64,66,68
		!byte 64,66,68,70,72,74,76,78
		!byte 112,114,116,118, 120,122,124,126

PLY1_ANMT_MVLFT_SIZE = 8
PLY1_ANMT_MVLFT
		;!byte 128,130,132,134,136,138,140,142
		!byte 80,82,84,86,88,90,92,94