;============================================================
; VIC-II Registers
;============================================================

; Main registers
VIC_CONTROL             = $d016
VIC_CONTROL2            = $d011
VIC_MEMORY_CONTROL      = $d018

; Sprite Position
VIC_SPRITE_X_POS        = $d000
VIC_SPRITE_Y_POS        = $d001
VIC_SPRITE_X_EXTEND     = $d010
VIC_SPRITE_ENABLE       = $d015

; Sprite Colors
VIC_SPRITE_MULTICOLOR   = $d01c
VIC_SPRITE_MULTICOLOR_1 = $d025
VIC_SPRITE_MULTICOLOR_2 = $d026
VIC_SPRITE_COLOR        = $d027
VIC_SPRITE1_COLOR        = $d027
VIC_SPRITE2_COLOR        = $d028
VIC_SPRITE3_COLOR        = $d029
VIC_SPRITE4_COLOR        = $d02a
VIC_SPRITE5_COLOR        = $d02b
VIC_SPRITE6_COLOR        = $d02c
VIC_SPRITE7_COLOR        = $d02d
VIC_SPRITE8_COLOR        = $d02e

; Other Colors
VIC_BORDER_COLOR        = $d020
VIC_BACKGROUND_COLOR    = $d021
VIC_CHARSET_MULTICOLOR_1= $d022
VIC_CHARSET_MULTICOLOR_2= $d023