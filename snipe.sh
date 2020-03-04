#!/bin/bash
#=============================================================================#
#  xsnipe, an X tool to send signals to X windows through xprop
#  Copyright (C) 2020 Bruno Conde Kind
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#=============================================================================#

pexit () {
  notify-send 'xsnipe' "$2" --urgency=low --expire-time=1500 --icon=dialog-error
  exit $1
}

prop="$(xprop)"

wpid="$(echo "$prop" | grep "_NET_WM_PID(CARDINAL)" | cut -f3 -d" " )"
[[ "$wpid" =~ ^[0-9]+$ ]] || pexit $? 'Invalid pid'

name="$(echo "$prop" | grep "WM_CLASS(STRING)"      | cut -f2 -d"\"")"

dmsg=$'Signal to send to: \n'"$name"

ksig="$(dmenu -p "$dmsg")"
[[ "$ksig" =~ ^[0-9]+$ ]] || pexit $? 'Invalid signal'

kill -$ksig $wpid
notify-send "$ksig sent to $name" --urgency=low --expire-time=1500

exit 0
