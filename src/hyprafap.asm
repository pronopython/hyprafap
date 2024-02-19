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

*=$0801  ; basic program start
.byte $0c, $08 ; pointer to next line of basic $080C
.byte $0a, $00 ; Basic Line Number $000A = 10
.byte $9e, $20, $32, $30, $36, $34, $00 ; SYS Token (2 Bytes) + "2064" + Zero Termination
.byte $00, $00, $00, $00 ; filler bytes up to address 2063

.include "headers.asm"

	jsr loaddir

	jsr set_background
	jsr init_multicolor
	jsr clear_multicolor

	jsr show_screen_1

	jsr cycle_images

	loop1				; TODO remove this infinite loop (border color cycle)
		inc $d020
	jmp loop1

.include "loaddir.asm"
.include "waitkey.asm"
.include "graphics.asm"
.include "loadimage.asm"
.include "control.asm"
.include "rle.asm"