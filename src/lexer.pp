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

unit lexer;

interface

uses
    parentheses;

type
    TTokenKind = (
        TkSign, TkInt, TkOperation,
        TkOpeningPar, TkClosingPar
    );

    TTokenPtr = ^TToken;
    TToken = record
        prev, next: TTokenPtr;
        case kind : TTokenKind of
            TkSign: (
                sign: char
            );
            TkInt: (
                i: int64;
                parsed: boolean
            );
            TkOperation: (
                op: char
            )
    end;

    TLexer = record
        parentheses: TParentheses;
        first, last: TTokenPtr;
        SyntaxError: boolean;
    end;

procedure LexerStart(var lexer: TLexer);
procedure LexerStop(var lexer: TLexer);
procedure LexerEmpty(var lexer: TLexer);
procedure LexerStep(var lexer: TLexer; c: char);


implementation

uses
    ascii;

procedure LexerStart(var lexer: TLexer);
begin
    ParenthesesInitialize(lexer.parentheses);
    lexer.first := nil;
    lexer.last := nil;
    lexer.SyntaxError := false
end;

procedure LexerStop(var lexer: TLexer);
begin
    if lexer.last = nil then
        exit;
    if (lexer.last^.kind = TkInt) then
        lexer.last^.parsed := true;
    if (lexer.last^.kind in [TkSign, TkOperation]) or
        not AreParenthesesBalanced(lexer.parentheses) then
    begin
        lexer.SyntaxError := true
    end
end;

procedure LexerEmpty(var lexer: TLexer);
var
    tmp: TTokenPtr;
begin
    ParenthesesEmpty(lexer.parentheses);
    while lexer.first <> nil do
    begin
        tmp := lexer.first;
        lexer.first := lexer.first^.next;
        dispose(tmp)
    end;
    lexer.last := nil
end;

procedure PushToken(var lexer: TLexer);
begin
    if lexer.first = nil then
    begin
        new(lexer.first);
        lexer.first^.prev := nil;
        lexer.first^.next := nil;
        lexer.last := lexer.first
    end
    else
    begin
        if lexer.last^.kind = TkInt then
        begin
            lexer.last^.parsed := true;
        end;
        new(lexer.last^.next);
        lexer.last^.next^.prev := lexer.last;
        lexer.last := lexer.last^.next;
        lexer.last^.next := nil
    end
end;

procedure LexerStepDigit(var lexer: TLexer; digit: byte);
var
    sign: char;
begin
    if (lexer.last <> nil) and (lexer.last^.kind = TkSign) then
    begin
        sign := lexer.last^.sign;
        lexer.last^.kind := TkInt;
        lexer.last^.i := digit;
        lexer.last^.parsed := false;
        if sign = '-' then
            lexer.last^.i := -lexer.last^.i
    end
    else
    begin
        if (lexer.last = nil) or (lexer.last^.kind <> TkInt) then
        begin
            PushToken(lexer);
            lexer.last^.kind := TkInt;
            lexer.last^.i := digit;
            lexer.last^.parsed := false
        end
        else
        begin
            if lexer.last^.parsed then
            begin
                lexer.SyntaxError := true;
                exit
            end;
            lexer.last^.i := lexer.last^.i * 10;
            if lexer.last^.i < 0 then
              dec(lexer.last^.i, digit)
            else
              inc(lexer.last^.i, digit)
        end
    end
end;

procedure LexerStep(var lexer: TLexer; c: char);
begin
    if ((lexer.last = nil) or
          ((lexer.last^.kind = TkOpeningPar) or
              ((lexer.last^.kind = TkOperation) and
                  (lexer.last^.sign in ['/', '%', '*'])))) and
        IsPlusOrMinus(c) then
    begin
        PushToken(lexer);
        lexer.last^.kind := TkSign;
        lexer.last^.sign := c
    end
    else if IsDigit(c) then
        LexerStepDigit(lexer, ord(c) - ord('0'))
    else if c in ['+', '-', '/', '%', '*'] then
    begin
        if (lexer.last = nil) or
            (lexer.last^.kind in [TkSign, TkOpeningPar, TkOperation]) then
        begin
            lexer.SyntaxError := true;
            exit
        end;
        PushToken(lexer);
        lexer.last^.kind := TkOperation;
        lexer.last^.op := c
    end
    else if c = '(' then
    begin
        if (lexer.last <> nil) and
            (lexer.last^.kind in [TkInt, TkClosingPar]) then
        begin
            lexer.SyntaxError := true;
            exit
        end;
        PushToken(lexer);
        lexer.last^.kind := TkOpeningPar;
        PushOpeningParenthesis(lexer.parentheses)
    end
    else if c = ')' then
    begin
        if AreParenthesesBalanced(lexer.parentheses) or
            ((lexer.last <> nil) and
                (lexer.last^.kind in [TkSign, TkOperation, TkOpeningPar])) then
        begin
            lexer.SyntaxError := true;
            exit
        end;
        PushToken(lexer);
        lexer.last^.kind := TkClosingPar;
        PushClosingParenthesis(lexer.parentheses)
    end
    else if IsWhiteSpace(c) then
    begin
        if (lexer.last <> nil) and (lexer.last^.kind = TkInt) then
            lexer.last^.parsed := true
    end
    else
        lexer.SyntaxError := true
end;

end.
