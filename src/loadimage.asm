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

	jsr $FFBD     ; call SETNAM
	lda #$01
	ldx $BA       ; last used device number
	bne no_last_device
		ldx #$08      ; default to device 8
	no_last_device
	ldy #$00      ; $00 means: load to new address
	jsr $FFBA     ; call SETLFS

	ldx #<bitmap_address
	ldy #>bitmap_address
	lda #$00      ; $00 means: load to memory (not verify)
	jsr $FFD5     ; call LOAD
	bcs error_image_load    ; if carry set, a load error has happened
        jmp copycolor	;RTS
	error_image_load
		; Accumulator contains BASIC error code
		; most likely errors:
		; A = $05 (DEVICE NOT PRESENT)
		; A = $04 (FILE NOT FOUND)
		; A = $1D (LOAD ERROR)
		; A = $00 (BREAK, RUN/STOP has been pressed during loading)

		;TODO error handling ...
	rts


copycolor

	lda 34576
	sta 53281

	ldx #250
	loop_copy_color
		lda scrdata-1,x
		sta scrram-1,x
		lda scrdata+249,x
		sta scrram+249,x
		lda scrdata+499,x
		sta scrram+499,x
		lda scrdata+749,x
		sta scrram+749,x

		lda coldata-1,x
		sta colram-1,x
		lda coldata+249,x
		sta colram+249,x
		lda coldata+499,x
		sta colram+499,x
		lda coldata+749,x
		sta colram+749,x

		dex
	bne loop_copy_color

	rts



