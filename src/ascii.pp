{   ascii.pp

    Copyright (C) 2022, 2023 Tamerlan Bimzhanov

    This file is part of ccalc.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

unit ascii;

interface

{ Returns true if character is a digit from 0 to 9, otherwise false }
function IsDigit(c: char): boolean;

{ Returns true if character is #9, #10 or ' ', otherwise false }
function IsWhiteSpace(c: char): boolean;

{ Returns true if character is #9 or ' ', otherwise false }
function IsTabOrSpace(c: char): boolean;

{ Returns true if character is '+' or '-', otherwise false }
function IsPlusOrMinus(c: char): boolean;

implementation

function IsDigit(c: char): boolean;
begin
    exit((c >= '0') and (c <= '9'))
end;

function IsWhiteSpace(c: char): boolean;
begin
    exit((c = #9) or (c = #10) or (c = ' '))
end;

function IsTabOrSpace(c: char): boolean;
begin
    exit((c = #9) or (c = ' '))
end;

function IsPlusOrMinus(c: char): boolean;
begin
    exit((c = '+') or (c = '-'))
end;

end.
