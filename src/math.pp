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

unit math;

interface

uses
    lexer;

const
    DivisionByZero = 1;

procedure Calculate(token: TTokenPtr; var res, code: int64);

implementation

procedure Expression(var token: TTokenPtr; var res, code: int64); forward;

procedure Primary(var token: TTokenPtr; var res, code: int64);
var
    sign: char;
begin
    case token^.kind of
        TkSign: begin
            sign := token^.sign;
            token := token^.next;
            if sign = '+' then
                Primary(token, res, code)
            else if sign = '-' then
            begin
                Primary(token, res, code);
                res := -res
            end
        end;
        TkInt: begin
            res := token^.i;
            token := token^.next
        end;
        TkOpeningPar: begin
            token := token^.next;
            Expression(token, res, code);
            token := token^.next
        end
    end
end;

procedure Term(var token: TTokenPtr; var res, code: int64);
var
    right: int64;
    op: char;
begin
    Primary(token, res, code);
    if code <> 0 then
        exit;
    while true do
    begin
        if (token = nil) or
            (token^.kind <> TkOperation) or
            not (token^.op in ['*', '/', '%']) then
        begin
            exit
        end;
        op := token^.op;
        token := token^.next;
        Primary(token, right, code);
        if code <> 0 then
            exit;
        if op = '*' then
            res := res * right
        else
        begin
            if right = 0 then
                code := DivisionByZero
            else if op = '/' then
                res := res div right
            else if op = '%' then
                res := res mod right
        end
    end
end;

procedure Expression(var token: TTokenPtr; var res, code: int64);
var
    right: int64;
    op: char;
begin
    Term(token, res, code);
    if code <> 0 then
        exit;
    while true do
    begin
        if (token = nil) or
            (token^.kind <> TkOperation) or
            not (token^.op in ['+', '-']) then
        begin
            exit
        end;
        op := token^.op;
        token := token^.next;
        Term(token, right, code);
        if code <> 0 then
            exit;
        if op = '+' then
            res := res + right
        else if op = '-' then
            res := res - right
    end
end;

procedure Calculate(token: TTokenPtr; var res, code: int64);
begin
    code := 0;
    Expression(token, res, code)
end;

end.
