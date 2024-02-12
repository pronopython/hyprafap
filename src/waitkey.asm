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

wait_key
	wait_key_loop
		jsr $FFE4		; Calling KERNAL GETIN 
	beq wait_key_loop
	rts


scan_key
	; return A: pressed key
	; modifies A,X,Y
	scan_key_loop
		jsr $ff9f	; SCNKEY
		jsr $ffe4	; GETIN
	beq scan_key_loop
	rts
