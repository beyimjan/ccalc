{   Copyright (C) 2022, 2023 Tamerlan Bimzhanov

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

unit debug;

interface

uses
    lexer;

procedure PrintTokens(var lexer: TLexer);

implementation

procedure PrintTokens(var lexer: TLexer);
var
    tmp: TTokenPtr;
begin
    tmp := lexer.first;
    while tmp <> nil do
    begin
        case tmp^.kind of
            TkSign:
                write(tmp^.sign);
            TkInt:
                write(tmp^.i);
            TkOperation:
                write(tmp^.op);
            TkOpeningPar:
                write('(');
            TkClosingPar:
                write(')')
        end;
        if tmp^.next <> nil then
            write(', ')
        else
            writeln;
        tmp := tmp^.next
    end
end;

end.
