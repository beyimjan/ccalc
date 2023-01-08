{   parentheses.pp

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

unit parentheses;

interface

type
    TParentheses = ^TParenthesis;
    TParenthesis = record
        next: TParentheses;
    end;

procedure ParenthesesInitialize(var parentheses: TParentheses);
procedure ParenthesesEmpty(var parentheses: TParentheses);

procedure PushOpeningParenthesis(var parentheses: TParentheses);
procedure PushClosingParenthesis(var parentheses: TParentheses);

function AreParenthesesBalanced(var parentheses: TParentheses): boolean;

implementation

procedure ParenthesesInitialize(var parentheses: TParentheses);
begin
    parentheses := nil
end;

procedure ParenthesesEmpty(var parentheses: TParentheses);
begin
    while not AreParenthesesBalanced(parentheses) do
        PushClosingParenthesis(parentheses)
end;

procedure PushOpeningParenthesis(var parentheses: TParentheses);
var
    tmp: TParentheses;
begin
    new(tmp);
    tmp^.next := parentheses;
    parentheses := tmp
end;

procedure PushClosingParenthesis(var parentheses: TParentheses);
var
    tmp: TParentheses;
begin
    tmp := parentheses;
    parentheses := parentheses^.next;
    dispose(tmp)
end;

function AreParenthesesBalanced(var parentheses: TParentheses): boolean;
begin
    exit(parentheses = nil)
end;

end.
