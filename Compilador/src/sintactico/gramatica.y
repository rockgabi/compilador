%{
package sintactico;

import lexico.*; 
import java.util.Hashtable;

%}

/** YACC Declarations **/
%token IF
%token ELSE
%token THEN
%token BEGIN
%token END
%token PRINT
%token FUNCTION
%token RETURN
%token ID
%token CTE
%token FIN
%token STRING
%token INT
%token COMPARADOR
%token FOR

%%

programa: declaraciones ejecutable FIN
;

declaraciones: 
| declaraciones declaracion;
;

declaracion: tipo lista_variables ';'
| FUNCTION ID '(' parametro ')' bloque_funcion
;

parametro: 
| tipo ID
;

tipo: INT 
| STRING
;

lista_variables: ID
| lista_variables ',' ID
;

ejecutable: sentencia
| bloque
;

bloque: '{' sentencias '}'
;

bloque_funcion:
;

llamado_funcion: ID '(' parametro ')' ';'
;

sentencias: sentencias sentencia
;

sentencia: sentencia_if
| sentencia_asignacion
;

sentencia_if: IF condicion bloque ELSE bloque
;

condicion: '(' comparacion ')'
;

comparacion: expresion COMPARADOR expresion
;

sentencia_asignacion: ID '=' expresion ';'
;

expresion : expresion '+' termino
| expresion '-' termino
| termino
;

termino : termino '*' factor
| termino '/' factor
| factor
;

factor: ID
| CTE
| '(' expresion ')'
;


%%

boolean finished = false;

int yylex()
{
    if (finished) {
        return 0;
    }
    
    boolean hasNext = anLexico.hasNext();
    if(!hasNext) {
        finished = true;
        return FIN;
    }

    Token t= anLexico.getNextToken();
    yylval = new ParserVal(t); //seteamos el token, como objeto de yylval
    yylval.ival = anLexico.getNroLinea();
    if(t== null)
            return YYERRCODE;
    Short s = (Short) Conversor.get(t.getPalabraReservada());

    return s.intValue();
}

void yyerror(String s)
{
    if(s.contains("under"))
        System.out.println("Error :"+s);
}

AnalizadorLexico anLexico;
public void addAnalizadorLexico( AnalizadorLexico al)
{
    anLexico = al;
}

public int parse() {
    return yyparse();
}

static Hashtable<String, Short> Conversor;
static {
	Conversor = new Hashtable<String, Short>();
	
	Conversor.put("string", STRING);
        Conversor.put("int", INT);
        Conversor.put("function", FUNCTION);
	Conversor.put("CTE", CTE);
	Conversor.put("ID", ID);
	Conversor.put("if", IF);
	Conversor.put( "else", ELSE);
	Conversor.put( "print", PRINT);
	Conversor.put( "for", FOR);
	Conversor.put( "<=", COMPARADOR);
	Conversor.put( "==", COMPARADOR);
	Conversor.put( ">=", COMPARADOR);
	Conversor.put( "!=", COMPARADOR);
	Conversor.put( "<", COMPARADOR);
	Conversor.put( ">", COMPARADOR);
	Conversor.put( ";", new Short((short) ';'));
	Conversor.put( ",", new Short((short) ','));
	Conversor.put( "=", new Short((short) '='));
	Conversor.put( "{", new Short((short)'{'));
	Conversor.put( "}", new Short((short)'}'));
	Conversor.put( "(", new Short((short)'('));
	Conversor.put( ")", new Short((short)')'));
	Conversor.put( "+", new Short((short)'+'));
	Conversor.put( "-", new Short((short)'-'));
	Conversor.put( "*", new Short((short)'*'));
	Conversor.put( "/", new Short((short)'/'));	
}