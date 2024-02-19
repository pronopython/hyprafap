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

cycle_images

	lda #$0
	sta current_image

	loop_cycle_image
		lda number_of_images
		beq no_images
			lda current_image
			jsr load_image_by_number
		no_images
		
		cycle_images_scan_key_loop

			jsr scan_key

			; == space ==

			cmp #32 ; space key
			beq keypress_space

			; == 0-9 ==

			cmp #48 ;0
			bcs check_number
			jmp cycle_images_scan_key_loop
			
			check_number
				cmp #58 ; ":" (one after "9")
				bcc handle_number

			; == a-f ==

			cmp #65 ; A
			bcs check_letter
			jmp cycle_images_scan_key_loop

			check_letter
				;cmp #71 ; "g" (one after "f")
				cmp #73 ; "i" (one after "h")
				bcc handle_letter

			; == I ==

			cmp #73 ; "I"
			beq keypress_I

			cmp #82 ; "R"
			beq keypress_R

			cmp #133 ; f1
			beq keypress_f1

			cmp #134 ; f3
			beq keypress_f3

			jmp cycle_images_scan_key_loop ; no supported keypress

			; == handle calculated keys (0-9,a-f) ==
			handle_number
				sec
				sbc #48
				;sta current_image
				jmp check_image_number_range

			handle_letter
				sec
				sbc #55	; 65 (letter A) - 55 = 10(th image)
				jmp check_image_number_range

			check_image_number_range
				cmp number_of_images
				bcs cycle_images_scan_key_loop
				sta current_image
				jmp loop_cycle_image

			; == handle individual keys ==

			keypress_space
				inc current_image
				jmp check_biggest_image_number

			keypress_I
				lda #0
				sta current_image
				jmp loop_cycle_image

			keypress_R
				jsr loaddir
				lda #0
				sta current_image
				jmp loop_cycle_image
			
			keypress_f1
				jsr show_screen_1
				jmp cycle_images_scan_key_loop 

			keypress_f3
				jsr show_screen_2
				jmp cycle_images_scan_key_loop 

			check_biggest_image_number
				lda current_image
				sec
				sbc number_of_images
				bne loop_cycle_image
				lda #$0
				sta current_image
				jmp loop_cycle_image
	rts

load_image_by_number
	; A: image number (0..number of images - 1)
	; uses $FB,$FC,$FD

	sta $FD ; remember image number

	tay
	lda image_types, y
	cmp #$0
	beq load_uncompressed

	lda #$3 ; load into buffer
	sta $FE

	lda $FD
	jsr get_filename_pointer
	lda $FD
	jsr calculate_image_filename_length
	ldx $FB
	ldy $FC

	jsr load_image

	lda active_shown_screen
	jsr decompress_buffer
	jsr show_selected_screen_after_load

	rts


	load_uncompressed

	lda active_shown_screen
	sta $FE

	lda $FD
	jsr get_filename_pointer
	lda $FD
	jsr calculate_image_filename_length
	ldx $FB
	ldy $FC


	jsr load_image

	jsr show_selected_screen_after_load

	rts

calculate_image_filename_length
	; A: image number (0..number of images - 1)
	; returns: length in A
	clc
	rol
	tay
	iny
	iny
	lda image_name_pointers, y
	clc
	dey
	dey
	sec
	sbc image_name_pointers, y
	rts

get_filename_pointer
	; A: image number (0..number of images - 1)
	; returns: FB<, FC>
	; uses $FB, $FC
	clc
	rol
	tay
	lda image_name_pointers, y
	sta $FB
	clc
	iny
	lda image_name_pointers, y
	sta $FC
	rts
