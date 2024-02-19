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

loaddir
	lda #>dir_start
	sta dir_length_high
	lda #<dir_start
	sta dir_length_low

	lda #$0
	sta number_of_images

; SETNAM - set dir filename "$"

	lda #dirname_end-dirname
	ldx #<dirname
	ldy #>dirname
	jsr $FFBD      ; call SETNAM

; SETLFS - set file parameters
	lda #$02       ; filenumber 2
	ldx $BA
	bne skip_device_number
		ldx #$08       ; default to device number 8
	skip_device_number
	ldy #$00       ; secondary address 0 (required for dir reading!)
	jsr $FFBA      ; call SETLFS


	jsr $FFC0		; call OPEN (open the directory)
	bcs loaddir_error		; quit if OPEN failed
	jmp loaddir_open_no_error

	loaddir_error
        ; Akkumulator contains BASIC error code

        ; most likely error:
        ; A = $05 (DEVICE NOT PRESENT)
		jmp exit_loaddir

	loaddir_open_no_error
	ldx #$02		; filenumber 2
 	jsr $FFC6		; call CHKIN

	ldy #$06       ; skip 4 bytes on the first dir line
	loop_4_bytes
	jsr loaddir_getbyte    ; get a byte from dir and ignore it
	dey
	bne loop_4_bytes

	loop_first_line
		jsr loaddir_getbyte    ; get a byte from dir and ignore it
	bne loop_first_line      ; continue until end of line


	loop_next_dir_line

		jsr loaddir_getbyte
		jsr loaddir_getbyte


		loop_begin_name
			jsr loaddir_getbyte
			cmp #34		; '"' char
		bne loop_begin_name


		jsr loaddir_getbyte ; load next char after '"'


		ldx dir_length_low	; remember current mem pointer for dir
		stx $FD
		ldx dir_length_high
		stx $FE

		loop_dir_chars

			; === Test suffix ===

			cmp #46		; .
			bne no_suffix
			jsr loaddir_store_acc_char

			; === Test koa ===

			jsr loaddir_getbyte
			cmp #75		; K
			bne test_gg ; test next suffix (gg)
			jsr loaddir_store_acc_char
			
			jsr loaddir_getbyte
			cmp #79		; O
			bne no_suffix
			jsr loaddir_store_acc_char
			
			jsr loaddir_getbyte
			cmp #65		; A
			bne no_suffix
			jsr loaddir_store_acc_char ; match!

			lda #$0 ; image type koa
			ldy number_of_images
			sta image_types, y

			found_image_store_filename
				; store beginning of current filename
				lda number_of_images
				clc
				rol
				tay
				lda $FD
				sta image_name_pointers, y
				clc
				iny
				lda $FE
				sta image_name_pointers, y
				clc
				iny
				lda dir_length_low
				sta image_name_pointers, y
				clc
				iny
				lda dir_length_high
				sta image_name_pointers, y

				; inc number of images
				clc
				inc number_of_images

				; save END

				jmp loop_end_name ; skip reset current mem pointer

			; === Test gg ===
			test_gg

			;jsr loaddir_getbyte
			cmp #71		; G
			bne no_suffix
			jsr loaddir_store_acc_char

			jsr loaddir_getbyte
			cmp #71		; G
			bne no_suffix
			jsr loaddir_store_acc_char

			lda #$01 ; image type gg
			ldy number_of_images
			sta image_types, y

			jmp found_image_store_filename

			no_suffix
	
			jsr loaddir_store_acc_char
        	jsr loaddir_getbyte	; load next byte to acc

			cmp #34		; '"' char
		bne loop_dir_chars

		ldx $FD
		stx dir_length_low	; reset current mem pointer for dir when no match
		ldx $FE
		stx dir_length_high


		loop_end_name
			jsr loaddir_getbyte
		bne loop_end_name      ; eol?

	jmp loop_next_dir_line      ; no RUN/STOP -> continue

	exit_loaddir
        lda #$02       ; filenumber 2
        jsr $FFC3      ; call CLOSE
        jsr $FFCC     ; call CLRCHN
        rts

	loaddir_getbyte
        JSR $FFB7      ; call READST (read status byte)
        BNE end_getbyte       ; read error or end of file
        	JMP $FFCF      ; call CHRIN (read byte from directory)
		end_getbyte
        PLA            ; don't return to dir reading loop
        PLA
        JMP exit_loaddir

	loaddir_store_acc_char
		; code to save dir to mem
		ldx dir_length_low	; load current mem pointer for dir
		stx $FB
		ldx dir_length_high
		stx $FC
		ldy #0
		sta ($FB),y		; save acc to mem
		
		inc dir_length_low	; inc pointer
		bne noroll_loaddir
		inc dir_length_high
		noroll_loaddir
		; done save to mem
		rts

;----------------------------------------------------------------------
; Symbols
;----------------------------------------------------------------------

dirname .text "$"      ; filename used to access directory
dirname_end
