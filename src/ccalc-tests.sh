#!/bin/sh
#
# ccalc-tests.sh
#
# Copyright (C) 2022 Tamerlan Bimzhanov
#
# This file is part of ccalc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

PROG=./ccalc

[ -f $PROG ] || { echo Couldn\'t find the program to test! >&2 ; exit 1 ; }

test1="4"
test1_res="= 4"

test2="3+3"
test2_res="= 6"

test3="9.5*2"
test3_res="Syntax error at pos: 2"

test4="3+3*3"
test4_res="= 12"

test5="(3+3)*3"
test5_res="= 18"

test6="1+1+1/0"
test6_res="Error: Division by zero!"

test7="1*1+1*1"
test7_res="= 2"

test8="1*1*1+1+1"
test8_res="= 3"

test9="2*(2+8)*3*3*3"
test9_res="= 540"

test10="(4+4+4+4)+4"
test10_res="= 20"

test11="(1+(1-1)*2)*2"
test11_res="= 2"

test12="(4+(4*4))*4)"
test12_res="Syntax error at pos: 12"

test13="2*(2+2*2+10)/2"
test13_res="= 16"

test14="("
test14_res="Syntax error at pos: 1"

test15="()"
test15_res="Syntax error at pos: 2"

test16="()*4"
test16_res="Syntax error at pos: 2"

test17="4*(4+4/3*4)/2"
test17_res="= 16"

test18="2*2+4/3"
test18_res="= 5"

test19="2/2*2+(2+4+4)-4"
test19_res="= 8"

test20="1-1"
test20_res="= 0"

test_count=20

i=1
while [ $i -le $test_count ]; do
    eval test_i=\$test$i
    test_res=`echo "$test_i" | $PROG`
    eval test_i_res=\$test${i}_res
    if [ "$test_res" != "$test_i_res" ]; then
        echo TEST $i FAILED!
        echo EXPECTED: "$test_i_res"
        echo GOT: "$test_res"
    fi
    i=$((i+1))
done
