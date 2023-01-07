{   clexer.pp

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

unit clexer;

interface

uses
    brackets;

type
    TTokenPtr = ^TToken;
    TTokenKind = (
        TnSign, TnInt, TnOperation,
        TnOBracket, TnCBracket
    );
    TToken = record
        prev, next: TTokenPtr;
        case kind : TTokenKind of
            TnSign: (
                sign: char
            );
            TnInt: (
                i: int64
            );
            TnOperation: (
                op: char
            )
    end;

    TLexer = record
        brackets: TBrackets;
        first, last: TTokenPtr;
        syntaxError: boolean;
    end;

procedure LexerStart(var lexer: TLexer);
procedure LexerStop(var lexer: TLexer);
procedure LexerStep(var lexer: TLexer; c: char);

{$IFDEF DEBUG}
procedure PrintTokens(var lexer: TLexer);
{$ENDIF}

procedure LexerClear(var lexer: TLexer);

implementation

uses
    chutils;

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
        new(lexer.last^.next);
        lexer.last^.next^.prev := lexer.last;
        lexer.last := lexer.last^.next;
        lexer.last^.next := nil
    end
end;

procedure LexerStart(var lexer: TLexer);
begin
    BracketsCreate(lexer.brackets);
    lexer.first := nil;
    lexer.last := nil;
    lexer.syntaxError := false
end;

procedure LexerStop(var lexer: TLexer);
begin
    if ((lexer.last <> nil) and
            (lexer.last^.kind in [TnSign, TnOperation])) or
        not BracketsBalanced(lexer.brackets) then
    begin
        lexer.syntaxError := true
    end
end;

procedure LexerStep(var lexer: TLexer; c: char);
var
    sign: char;
begin
    if ((lexer.last = nil) or (lexer.last^.kind = TnOBracket)) and
        IsPlusOrMinus(c) then
    begin
        PushToken(lexer);
        lexer.last^.kind := TnSign;
        lexer.last^.sign := c
    end
    else if IsDigit(c) then
    begin
        if (lexer.last <> nil) and (lexer.last^.kind = TnSign) then
        begin
            if c = '0' then
                exit;
            sign := lexer.last^.sign;
            lexer.last^.kind := TnInt;
            lexer.last^.i := ord(c) - ord('0');
            if sign = '-' then
                lexer.last^.i := -lexer.last^.i
        end
        else
        begin
            if (lexer.last = nil) or (lexer.last^.kind <> TnInt) then
            begin
                PushToken(lexer);
                lexer.last^.kind := TnInt;
                lexer.last^.i := ord(c) - ord('0')
            end
            else
                lexer.last^.i := lexer.last^.i * 10 + ord(c) - ord('0')
        end
    end
    else if c in ['+', '-', '/', '%', '*'] then
    begin
        if (lexer.last = nil) or
            (lexer.last^.kind in [TnSign, TnOBracket, TnOperation]) then
        begin
            lexer.syntaxError := true;
            exit
        end;
        PushToken(lexer);
        lexer.last^.kind := TnOperation;
        lexer.last^.op := c
    end
    else if c = '(' then
    begin
        if (lexer.last <> nil) and
            (lexer.last^.kind in [TnInt, TnCBracket]) then
        begin
            lexer.syntaxError := true;
            exit
        end;
        PushToken(lexer);
        lexer.last^.kind := TnOBracket;
        PushOBracket(lexer.brackets)
    end
    else if c = ')' then
    begin
        if BracketsBalanced(lexer.brackets) or
            ((lexer.last <> nil) and
                (lexer.last^.kind in [TnSign, TnOperation, TnOBracket])) then
        begin
            lexer.syntaxError := true;
            exit
        end;
        PushToken(lexer);
        lexer.last^.kind := TnCBracket;
        PushCBracket(lexer.brackets)
    end
    else if not IsWhitespace(c) then
        lexer.syntaxError := true
end;

{$IFDEF DEBUG}
procedure PrintTokens(var lexer: TLexer);
var
    tmp: TTokenPtr;
begin
    tmp := lexer.first;
    while tmp <> nil do
    begin
        case tmp^.kind of
            TnSign:
                write(tmp^.sign);
            TnInt:
                write(tmp^.i);
            TnOperation:
                write(tmp^.op);
            TnOBracket:
                write('(');
            TnCBracket:
                write(')')
        end;
        if tmp^.next <> nil then
            write(', ')
        else
            writeln;
        tmp := tmp^.next
    end
end;
{$ENDIF}

procedure LexerClear(var lexer: TLexer);
var
    tmp: TTokenPtr;
begin
    BracketsClear(lexer.brackets);
    while lexer.first <> nil do
    begin
        tmp := lexer.first;
        lexer.first := lexer.first^.next;
        dispose(tmp)
    end;
    lexer.last := nil
end;

end.
