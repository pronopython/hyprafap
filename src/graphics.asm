;----------------------------------------------------------------------------------------------
;
; HypraFap - Retro Fapping System
;
; For updates see git-repo at
; https://github.com/pronopython/hyprafap
;
;----------------------------------------------------------------------------------------------
;
; Copyright (C) PronoPython
;
; Contact me at pronopython@proton.me
;
; This program is free software: you can redistribute it and/or modify it
; under the terms of the GNU General Public License as published by the
; Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
;----------------------------------------------------------------------------------------------
;
; Turbo Macro Pro cross assembler code for Commodore 64 / 6502 CPU
;

init_multicolor

	lda 53265		; Multicolor mode
	ora #32
	sta 53265
	
	lda 53270
	ora #16
	sta 53270
	
	lda #$78	; 1c00 local start address for screen ram
	sta $d018
	
	lda $dd00
	and #252
	ora #3-1
	sta $dd00

	rts

clear_multicolor
	; clear color 0
	lda #$0
	sta $d021 

	jsr clear_screen_1
	jsr clear_screen_2
	jsr clear_color_data_1
	jsr clear_color_data_2
	jsr clear_color_ram



clear_screen_1
	; clear bitmap
	ldy #$0
	lda #$0     ;$0 / $1b = 00011011 all bit patterns
	clear1_1
		sta bitmap_1,y
		sta bitmap_1+$100,y
		sta bitmap_1+$200,y
		sta bitmap_1+$300,y
		sta bitmap_1+$400,y
		sta bitmap_1+$500,y
		sta bitmap_1+$600,y
		sta bitmap_1+$700,y
		sta bitmap_1+$800,y
		sta bitmap_1+$900,y
		sta bitmap_1+$A00,y
		sta bitmap_1+$B00,y
		sta bitmap_1+$C00,y
		sta bitmap_1+$D00,y
		sta bitmap_1+$E00,y
		sta bitmap_1+$F00,y
		sta bitmap_1+$1000,y
		sta bitmap_1+$1100,y
		sta bitmap_1+$1200,y
		sta bitmap_1+$1300,y
		sta bitmap_1+$1400,y
		sta bitmap_1+$1500,y
		sta bitmap_1+$1600,y
		sta bitmap_1+$1700,y
		sta bitmap_1+$1800,y
		sta bitmap_1+$1900,y
		sta bitmap_1+$1A00,y
		sta bitmap_1+$1B00,y
		sta bitmap_1+$1C00,y
		sta bitmap_1+$1D00,y
		sta bitmap_1+$1E00,y
		iny
	bne clear1_1


	ldy #$40 ; last 64 bytes of bitmap
	sec
	lda #$0
	clear2_1
		dey
		sta bitmap_1+$1F00,y
	bne clear2_1

	; clear screen ram (color 1,2)

	ldx #250
	lda #$CF ; colors
	clear3_1
		sta screen_ram_1-1,x
		sta screen_ram_1+249,x
		sta screen_ram_1+499,x
		sta screen_ram_1+749,x
		dex
	bne clear3_1
	rts


clear_screen_2
	; clear bitmap
	ldy #$0
	lda #$0 ;e4 = 11100100
	clear1_2
		sta bitmap_2,y
		sta bitmap_2+$100,y
		sta bitmap_2+$200,y
		sta bitmap_2+$300,y
		sta bitmap_2+$400,y
		sta bitmap_2+$500,y
		sta bitmap_2+$600,y
		sta bitmap_2+$700,y
		sta bitmap_2+$800,y
		sta bitmap_2+$900,y
		sta bitmap_2+$A00,y
		sta bitmap_2+$B00,y
		sta bitmap_2+$C00,y
		sta bitmap_2+$D00,y
		sta bitmap_2+$E00,y
		sta bitmap_2+$F00,y
		sta bitmap_2+$1000,y
		sta bitmap_2+$1100,y
		sta bitmap_2+$1200,y
		sta bitmap_2+$1300,y
		sta bitmap_2+$1400,y
		sta bitmap_2+$1500,y
		sta bitmap_2+$1600,y
		sta bitmap_2+$1700,y
		sta bitmap_2+$1800,y
		sta bitmap_2+$1900,y
		sta bitmap_2+$1A00,y
		sta bitmap_2+$1B00,y
		sta bitmap_2+$1C00,y
		sta bitmap_2+$1D00,y
		sta bitmap_2+$1E00,y
		iny
	bne clear1_2


	ldy #$40 ; last 64 bytes of bitmap
	sec
	clear2_2
		dey
		sta bitmap_2+$1F00,y
	bne clear2_2

	; clear screen ram (color 1,2)

	ldx #250
	lda #$CF ; colors
	clear3_2
		sta screen_ram_2-1,x
		sta screen_ram_2+249,x
		sta screen_ram_2+499,x
		sta screen_ram_2+749,x
		dex
	bne clear3_2
	rts

clear_color_ram
	; clear color ram (color 3)
	ldx #250
	lda #$11
	clear4
		sta color_ram-1,x
		sta color_ram+249,x
		sta color_ram+499,x
		sta color_ram+749,x
		dex
	bne clear4

	rts

clear_color_data_1
	ldx #250
	lda #$11
	clear_cd1
		sta color_data_1-1,x
		sta color_data_1+249,x
		sta color_data_1+499,x
		sta color_data_1+749,x
		dex
	bne clear_cd1

	lda #$0
	sta $4710
	
	rts

clear_color_data_2
	ldx #250
	lda #$11
	clear_cd2
		sta color_data_2-1,x
		sta color_data_2+249,x
		sta color_data_2+499,x
		sta color_data_2+749,x
		dex
	bne clear_cd2
	
	lda #$0
	sta $8710
	
	rts


set_background
	lda #$0
	sta $d020
	sta $d021
	rts

show_selected_screen
	lda active_shown_screen
	cmp #$0
	beq set_screen_1
	jmp show_screen_2
	set_screen_1
		jmp show_screen_1

show_selected_screen_after_load
	lda active_shown_screen
	cmp #$0
	beq set_init_screen_1
	jmp init_screen_2
	set_init_screen_1
		jmp init_screen_1



show_screen_1

; switch video bank
	lda $dd00
	and #$fc
	ora #$3
	sta $dd00

; switch bitmap + screen ram
	lda #$19		;b00011001
	sta $d018

; load color 0
	lda $4710
	sta 53281

	jsr copycolorram_screen_1

	lda #$0
	sta active_shown_screen

	rts


show_screen_2

; switch video bank
	lda $dd00
	and #252
	ora #3-1
	sta $dd00

; switch bitmap + screen ram
	lda #$78	; 1c00 local start address for screen ram
	sta $d018

; load color 0
	lda $8710
	sta 53281

	jsr copycolorram_screen_2

	lda #$1
	sta active_shown_screen

	rts



init_screen_1

; switch video bank
	lda $dd00
	and #$fc
	ora #$3
	sta $dd00

; switch bitmap + screen ram
	lda #$19		;b00011001
	sta $d018

; load color 0
	lda $4710
	sta 53281

	jsr copycolorram_and_screenram_screen_1

	lda #$0
	sta active_shown_screen

	rts


init_screen_2

; switch video bank
	lda $dd00
	and #252
	ora #3-1
	sta $dd00

; switch bitmap + screen ram
	lda #$78	; 1c00 local start address for screen ram
	sta $d018

; load color 0
	lda $8710
	sta 53281

	jsr copycolorram_and_screenram_screen_2

	lda #$1
	sta active_shown_screen

	rts




copycolorram_screen_1
	ldx #250
	loop_copy_color_screen_1
		lda color_data_1-1,x
		sta color_ram-1,x
		lda color_data_1+249,x
		sta color_ram+249,x
		lda color_data_1+499,x
		sta color_ram+499,x
		lda color_data_1+749,x
		sta color_ram+749,x

		dex
	bne loop_copy_color_screen_1

	rts

copycolorram_screen_2
	ldx #250
	loop_copy_color_screen_2
		lda color_data_2-1,x
		sta color_ram-1,x
		lda color_data_2+249,x
		sta color_ram+249,x
		lda color_data_2+499,x
		sta color_ram+499,x
		lda color_data_2+749,x
		sta color_ram+749,x

		dex
	bne loop_copy_color_screen_2

	rts

copycolorram_and_screenram_screen_1

	;lda 34576
	;sta 53281

	ldx #250
	loop_copy_colorram_and_screenram_1
		lda screen_data_1-1,x
		sta screen_ram_1-1,x
		lda screen_data_1+249,x
		sta screen_ram_1+249,x
		lda screen_data_1+499,x
		sta screen_ram_1+499,x
		lda screen_data_1+749,x
		sta screen_ram_1+749,x

		lda color_data_1-1,x
		sta color_ram-1,x
		lda color_data_1+249,x
		sta color_ram+249,x
		lda color_data_1+499,x
		sta color_ram+499,x
		lda color_data_1+749,x
		sta color_ram+749,x

		dex
	bne loop_copy_colorram_and_screenram_1

	rts

copycolorram_and_screenram_screen_2

	;lda 34576
	;sta 53281

	ldx #250
	loop_copy_colorram_and_screenram_2
		lda screen_data_2-1,x
		sta screen_ram_2-1,x
		lda screen_data_2+249,x
		sta screen_ram_2+249,x
		lda screen_data_2+499,x
		sta screen_ram_2+499,x
		lda screen_data_2+749,x
		sta screen_ram_2+749,x

		lda color_data_2-1,x
		sta color_ram-1,x
		lda color_data_2+249,x
		sta color_ram+249,x
		lda color_data_2+499,x
		sta color_ram+499,x
		lda color_data_2+749,x
		sta color_ram+749,x

		dex
	bne loop_copy_colorram_and_screenram_2

	rts