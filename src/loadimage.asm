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

load_image
	; A length filename
	; X < image name
	; Y > image name
	; $FE Bank (0: screen 1, 1: screen 2, 3: buffer 1)

	jsr $FFBD     ; call SETNAM

	lda #$0
	sta last_load_end_address_low
	sta last_load_end_address_high

	lda #$01
	ldx $BA       ; last used device number
	bne no_last_device
		ldx #$08      ; default to device 8
	no_last_device
	ldy #$00      ; $00 means: load to new address
	jsr $FFBA     ; call SETLFS

	ldx #<bitmap_1
	ldy #>bitmap_1
	lda $FE
	cmp #$0
	beq set_image_ok
		ldx #<bitmap_2
		ldy #>bitmap_2
		cmp #$1
		beq set_image_ok
			ldx #<buffer_1
			ldy #>buffer_1
			; turn basic rom off
			lda #$36
			sta $0001
		
	set_image_ok
	
	lda #$00      ; $00 means: load to memory (not verify)
	jsr $FFD5     ; call LOAD
	bcs error_image_load    ; if carry set, a load error has happened
		stx last_load_end_address_low
		sty last_load_end_address_high
        ;jmp copycolor	;RTS
		; turn basic rom on
		lda #$37
		sta $0001
		rts
	error_image_load
		; Accumulator contains BASIC error code
		; most likely errors:
		; A = $05 (DEVICE NOT PRESENT)
		; A = $04 (FILE NOT FOUND)
		; A = $1D (LOAD ERROR)
		; A = $00 (BREAK, RUN/STOP has been pressed during loading)

		;TODO error handling ...
	rts

;copycolor

;	lda 34576
;	sta 53281

;	ldx #250
;	loop_copy_color
;		lda screen_data_2-1,x
;		sta screen_ram_2-1,x
;		lda screen_data_2+249,x
;		sta screen_ram_2+249,x
;		lda screen_data_2+499,x
;		sta screen_ram_2+499,x
;		lda screen_data_2+749,x
;		sta screen_ram_2+749,x

;		lda color_data_2-1,x
;		sta color_ram-1,x
;		lda color_data_2+249,x
;		sta color_ram+249,x
;		lda color_data_2+499,x
;		sta color_ram+499,x
;		lda color_data_2+749,x
;		sta color_ram+749,x

;		dex
;	bne loop_copy_color

;	rts



