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
last_load_end_address_low = $C322
last_load_end_address_high = $C323
active_shown_screen = $C324
;...
image_name_pointers = $C325 ; space for 100 images...

image_types = $C400

dir_length_high = $C581 ; high byte counter
dir_length_low = $C582  ; low byte counter
dir_start = $C583	; write dir starting here

;bitmap 1 = screen 1
bitmap_1 = $2000
screen_data_1 = $3f40
color_data_1 = $4328
common_color_1 = $4710 ; also last byte of screen 1
screen_ram_1 = $400

;bitmap 2 = screen 2
bitmap_2 = $6000
screen_data_2 = 32576
color_data_2 = 33576
common_color_2 = $8710 ; also last byte of screen 2
screen_ram_2 = 23552

;color ram
color_ram = 55296

;buffer 1
buffer_1 = $9000

