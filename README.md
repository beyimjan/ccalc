# CCalc
CCalc is a calculator with a simple console interface, written in Free Pascal.

## Features
```
$ ./ccalc
1+2
= 3
4+
Syntax error at pos: 2
4+4*4
= 20
4+(4+4)*4+4
= 40
4-16%5
= 3
-5*4
= -20
```

## Limitations
It can only perform calculations with integers.

## Installation
Binary downloads of the calculator can be found on [the Releases page](https://github.com/bimzhanovt/ccalc/releases).

To compile the program from source, you will need to install the `fpc` compiler and `make`. Then, give the following commands:
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
