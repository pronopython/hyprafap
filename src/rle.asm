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

decompress_buffer
	; A destination screen
	; uses: f7, f8, f9, fa, fb, fc, fd, fe

	; $F7 destinaton screen 0/1
	; $F8 <last destination byte
	; $F9 >last destination byte
	; $FA byte to be repeated (temp)
	; $FB <buffer pos
	; $FC >  "
	; $FD <destination pos
	; $FE >  "

	sta $f7 ; destinaton screen

	lda #<buffer_1
	sta $fb
	lda #>buffer_1
	sta $fc

	lda #<bitmap_1
	sta $fd
	lda #>bitmap_1
	sta $fe
	lda #<common_color_1 ; also last byte of screen 1
	sta $f8
	lda #>common_color_1
	sta $f9

	lda $f7
	cmp #$0
	beq bitmap1_destination
		lda #<bitmap_2
		sta $fd
		lda #>bitmap_2
		sta $fe
		lda #<common_color_2 ; also last byte of screen 2
		sta $f8
		lda #>common_color_2
		sta $f9
	bitmap1_destination

	; turn basic rom off
	lda #$36
	sta $0001

	rle_loop

		; load next byte from buffer
		ldy #0
		lda ($FB),y		; load from buffer
		
		cmp #$FE		; Run Length Encoding escape byte?
		beq escape_found
		
			ldy #0
			sta ($fd),y		; store to screen

			; check if done
			clc
			lda $fd
			cmp $f8
			bcc advance_pointers_1
			lda $fe
			cmp $f9
			bcc advance_pointers_1
			jmp exit_rle

			advance_pointers_1

			inc $fd
			bne done_inc_bitmap_pointer
			inc $fe
			done_inc_bitmap_pointer

			jsr increment_buffer

			jmp rle_loop

		escape_found
			; Escape Sequence for RLE is:
			;`$FE [identical byte] [number of repetitions]`

			jsr increment_buffer
	
			ldy #0
			lda ($fb), y ; load byte to be repeated ("identical byte")
			sta $fa

			jsr increment_buffer

			ldy #0
			lda ($fb), y ; load number of repetitions
			
			tay

			lda $fa

			loop_repetitions
				dey

				sta ($fd), y

				cpy #$0
				bne loop_repetitions

			ldy #0
			lda ($fb), y ; load number of repetitions, again
			
			cmp #$0 ; $0 in repetitions means 256 repetitions
			beq inc_high
			clc
			adc $fd
			sta $fd
			bcc no_inc_high

			inc_high
			inc $fe
			no_inc_high

			; check if done
			clc
			lda $fd
			cmp $f8
			bcc advance_pointers_2
			beq advance_pointers_2
			lda $fe
			cmp $f9
			bcc advance_pointers_2
			beq advance_pointers_2
			jmp exit_rle

			advance_pointers_2
			jsr increment_buffer

		jmp rle_loop
	jmp exit_rle

	increment_buffer
		inc $fb
		bne done_inc_buffer_pointer_2
		inc $fc
		done_inc_buffer_pointer_2
		rts

	exit_rle
		; turn basic rom on
		lda #$37
		sta $0001
		rts