import java_cup.runtime.*;

%%
%line
%column
%cup
%class Lexer
%caseless
%standalone

/* INSTRUCTORS! Large portions of this code are adapted and implemented from documentation
at JFlex.de and http://www.tldp.org/LDP/LG/issue41/lopes/lopes.html. It is our opinion that
construction of this compiler would have been immensely difficult without these resources.*/

%{
      StringBuffer string = new StringBuffer();

     private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }

%}

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
DecIntegerLiteral = 0 | [1-9][0-9]*
Ident = [A-Za-z_][A-Za-z_0-9]*
InputCharacter = [^\r\n]


MultilineComment = "/*" [^*] ~"*/"
EOLComment = "//" {InputCharacter}* {LineTerminator}?
Comment = {MultilineComment} | {EOLComment}



%state STRING

%%
<YYINITIAL> {
"+"                     { System.out.print(" + "); return symbol(sym.PLUS); }
";"                     { return symbol(sym.SEMI); }
"-"                     { System.out.print(" - "); return symbol(sym.MINUS); }
"*"                     { System.out.print(" * "); return symbol(sym.TIMES); }
"/"                     { System.out.print(" / "); return symbol(sym.DIVIDE); }
"%"                     { System.out.print(" % "); return symbol(sym.MODULO);}
"<<"                    { System.out.print(" << "); return symbol(sym.SHIFTLEFT); }
">>"                    { System.out.print(" >> "); return symbol(sym.SHIFTRIGHT); }
"=="                    { System.out.print(" == "); return symbol(sym.EQEQ); }
">="                    { System.out.print(" >= "); return symbol(sym.GREATEQ); }
"<="                    { System.out.print(" <= "); return symbol(sym.LESSEQ); }
"<"                     { System.out.print(" < "); return symbol(sym.LESS); }
">"                     { System.out.print(" > "); return symbol(sym.GREATER); }
"="                     { System.out.print(" = "); return symbol(sym.EQ); }
"FOR"                   { System.out.print(" FOR "); return symbol(sym.FOR); }
"DO"                    { System.out.print(" DO "); return symbol(sym.DO); }
"IF"                    { System.out.print(" IF "); return symbol(sym.IF); }
"ELSE"                  { System.out.print(" ELSE "); return symbol(sym.ELSE); }
"WHILE"                 { System.out.print(" WHILE "); return symbol(sym.WHILE); }
"RETURN"                { System.out.print(" RETURN "); return symbol(sym.RETURN); }
"extern"                { System.out.print(" EXTERN "); return symbol(sym.EXTERN); }
"INT"                   { System.out.print(" INT "); return symbol(sym.CONSTINT); }
"STRING"                { System.out.print(" STRING "); return symbol(sym.CONSTSTRING); }
"("                     { System.out.print(" ( "); return symbol(sym.LPARENS); }
")"                     { System.out.print(" ) "); return symbol(sym.RPARENS); }

/* If the parse isn't satisfied by any of the preceding exact matches, then try other parse
rules */

/* tokenize integers to NUMBER symbol with value of the integer that is held in the string yytext */
{DecIntegerLiteral}         { System.out.print(yytext());
                          return symbol(sym.CONSTINT, new Integer(yytext())); }

/* Tokenize IDENTS. This is why strings must be instantiated within quotes! */
{Ident}                 { System.out.print(yytext());
                          return symbol(sym.IDENT, new Integer(1));}
/* Ignore hecklers */
{WhiteSpace}            {/*ignore*/}
{Comment}               {/*ignore*/}

/* Macro City: Find and Replace */
//TODO: Find and Replace Preprocessor
}
<STRING> {
      \"                             { yybegin(YYINITIAL);
                                       return symbol(sym.CONSTSTRING,
                                       string.toString()); }
      [^\n\r\"\\]+                   { string.append( yytext() ); }
      \\t                            { string.append('\t'); }
      \\n                            { string.append('\n'); }

      \\r                            { string.append('\r'); }
      \\\"                           { string.append('\"'); }
      \\                             { string.append('\\'); }
    }