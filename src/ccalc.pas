{   ccalc.pas

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

program ccalc;

uses
    lexer, math;

const
    SyntaxError = 'Syntax error at pos: ';

type
    TCCalc = record
        start: boolean;
        lexer: TLexer;
        x: int64;
    end;

procedure CCalcStart(var calc: TCCalc);
begin
    LexerStart(calc.lexer);
    calc.x := 0;
    calc.start := false
end;

procedure CCalcStringTerminatedHandler(var calc: TCCalc);
var
    res, code: int64;
begin
    LexerStop(calc.lexer);
    if calc.lexer.first <> nil then
    begin
        if calc.lexer.syntaxError then
            writeln(SyntaxError, calc.x)
        else
        begin
{$IFDEF DEBUG}
            write('< ');
            PrintTokens(calc.lexer);
{$ENDIF}
            Calculate(calc.lexer.first, res, code);
            if code = 0 then
                writeln('= ', res)
            else if code = DivisionByZero then
                writeln('Error: Division by zero!')
        end
    end;
    LexerEmpty(calc.lexer);
    calc.start := true
end;

var
    c: char;
    calc: TCCalc;
begin
    calc.start := true;
    while true do
    begin
        if calc.start then
            CCalcStart(calc)
        else if eof then
        begin
            CCalcStringTerminatedHandler(calc);
            break
        end
        else
        begin
            read(c);
            if c = #10 then
                CCalcStringTerminatedHandler(calc)
            else
            begin
                inc(calc.x);
                LexerStep(calc.lexer, c);
                if calc.lexer.syntaxError then
                begin
                    readln;
                    LexerEmpty(calc.lexer);
                    calc.start := true;
                    writeln(SyntaxError, calc.x)
                end
            end
        end
    end
end.
