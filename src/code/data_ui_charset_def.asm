; --- UI CHARACTERS DEFINITION ---
; This file is used by reorder_map.py to inject UI characters into the map charset.

; 'L' (index 67 if map has 67 chars)
ui_char_l_bitmap
!byte $60, $60, $60, $60, $60, $60, $7E, $00
ui_char_l_attrib
!byte 1

; '=' (index 68)
ui_char_eq_bitmap
!byte $00, $00, $7E, $00, $7E, $00, $00, $00
ui_char_eq_attrib
!byte 1

; '0'-'9' (indices 69-78)
ui_chars_digits_bitmaps
!byte $3C, $66, $6E, $7E, $76, $66, $3C, $00 ; 0
!byte $18, $38, $18, $18, $18, $18, $7E, $00 ; 1
!byte $3C, $66, $06, $0C, $18, $30, $7E, $00 ; 2
!byte $3C, $66, $06, $1C, $06, $66, $3C, $00 ; 3
!byte $1C, $3C, $6C, $CC, $FE, $0C, $0C, $00 ; 4
!byte $7E, $60, $7C, $06, $06, $66, $3C, $00 ; 5
!byte $3C, $66, $60, $7C, $66, $66, $3C, $00 ; 6
!byte $7E, $66, $0C, $18, $18, $18, $18, $00 ; 7
!byte $3C, $66, $66, $3C, $66, $66, $3C, $00 ; 8
!byte $3C, $66, $66, $3E, $06, $66, $3C, $00 ; 9

ui_chars_digits_attribs
!byte 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
