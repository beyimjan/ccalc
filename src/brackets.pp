{   brackets.pp

    Copyright (C) 2022 Tamerlan Bimzhanov

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

unit brackets;

interface

type
    TBrackets = ^TBracket;
    TBracket = record
        next: TBrackets;
    end;

procedure BracketsCreate(var brackets: TBrackets);
procedure BracketsClear(var brackets: TBrackets);

procedure PushOBracket(var brackets: TBrackets);
procedure PushCBracket(var brackets: TBrackets);

function BracketsBalanced(var brackets: TBrackets): boolean;

implementation

procedure BracketsCreate(var brackets: TBrackets);
begin
    brackets := nil
end;

procedure BracketsClear(var brackets: TBrackets);
begin
    while not BracketsBalanced(brackets) do
        PushCBracket(brackets)
end;

procedure PushOBracket(var brackets: TBrackets);
var
    tmp: TBrackets;
begin
    new(tmp);
    tmp^.next := brackets;
    brackets := tmp
end;

procedure PushCBracket(var brackets: TBrackets);
var
    tmp: TBrackets;
begin
    tmp := brackets;
    brackets := brackets^.next;
    dispose(tmp)
end;

function BracketsBalanced(var brackets: TBrackets): boolean;
begin
    exit(brackets = nil)
end;

end.
