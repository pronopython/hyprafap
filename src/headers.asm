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

number_of_images = $C320
current_image = $C321
image_name_pointers = $C322

dir_length_high = $C581 ; high byte counter
dir_length_low = $C582  ; low byte counter
dir_start = $C583	; write dir starting here


bitmap_address = $6000  ; koala $6000
scrdata = 32576
coldata = 33576
scrram = 23552
colram = 55296



