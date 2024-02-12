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
	sta 53272
	
	lda 56576
	and #252
	ora #3-1
	sta 56576

	rts

clear_multicolor
	; clear color 0
	lda #$0
	sta $d021 

	; clear bitmap
	ldy #$0
	tya
	clear1
		sta bitmap_address,y
		sta bitmap_address+$100,y
		sta bitmap_address+$200,y
		sta bitmap_address+$300,y
		sta bitmap_address+$400,y
		sta bitmap_address+$500,y
		sta bitmap_address+$600,y
		sta bitmap_address+$700,y
		sta bitmap_address+$800,y
		sta bitmap_address+$900,y
		sta bitmap_address+$A00,y
		sta bitmap_address+$B00,y
		sta bitmap_address+$C00,y
		sta bitmap_address+$D00,y
		sta bitmap_address+$E00,y
		sta bitmap_address+$F00,y
		sta bitmap_address+$1000,y
		sta bitmap_address+$1100,y
		sta bitmap_address+$1200,y
		sta bitmap_address+$1300,y
		sta bitmap_address+$1400,y
		sta bitmap_address+$1500,y
		sta bitmap_address+$1600,y
		sta bitmap_address+$1700,y
		sta bitmap_address+$1800,y
		sta bitmap_address+$1900,y
		sta bitmap_address+$1A00,y
		sta bitmap_address+$1B00,y
		sta bitmap_address+$1C00,y
		sta bitmap_address+$1D00,y
		sta bitmap_address+$1E00,y
		iny
	bne clear1


	ldy #$40 ; last 64 bytes of bitmap
	sec
	clear2
		dey
		sta bitmap_address+$1F00,y
	bne clear2

	; clear screen ram (color 1,2)

	ldx #250
	lda #$CF ; colors
	clear3
		sta scrram-1,x
		sta scrram+249,x
		sta scrram+499,x
		sta scrram+749,x
		dex
	bne clear3

	; clear color ram (color 3)

	ldx #250
	lda #$11
	clear4
		sta colram-1,x
		sta colram+249,x
		sta colram+499,x
		sta colram+749,x
		dex
	bne clear4

	rts

set_background
	lda #$0
	sta $d020
	sta $d021
	rts