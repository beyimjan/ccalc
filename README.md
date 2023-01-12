# CCalc
CCalc is a calculator with a simple console interface, written in Free Pascal.

It can only perform calculations with integers.

## Illustrating the Functionality
```
$ ./ccalc
1 + 2
= 3
4 +
Syntax error at pos: 3
4 + 4 * 4
= 20
4 + (4 + 4) * 4 + 4
= 40
4 - 16 % 5
= 3
```

## Compilation dependencies
To compile the program, you will need the `fpc` compiler and `make`.

## How to Use
```sh
$ cd src/
$ make
$ ./ccalc
```

## License
CCalc is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.


This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
