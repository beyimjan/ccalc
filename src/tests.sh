#!/bin/sh
#
#   tests.sh
#
#   Copyright (C) 2022 Tamerlan Bimzhanov
#
#   This file is part of ccalc.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.

prog=./ccalc

[ -f $prog ] || { echo Couldn\'t find the program to test! >&2 ; exit 1 ; }

while read question && read answer; do
    result=`echo "$question" | $prog`
    if [ "$result" != "$answer" ]; then
        echo TEST "'${question}'" FAILED!
        echo EXPECTED: "'$answer'"
        echo GOT: "'$result'"
    fi
done < tests.txt