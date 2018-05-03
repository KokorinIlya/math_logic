%{
open Tree;;
%}
%token <string> VAR
%token IMPL AND OR NOT
%token OPEN CLOSE
%token DEQ COMMA
%token EOF
%right IMPL
%left DEQ
%left COMMA
%left OR
%left AND
%nonassoc NOT
%start main
%start all_input
%type <Tree.tree> main
%type <(Tree.tree list) * Tree.tree> all_input
%%
main:
        exp EOF          { $1 }
exp:
        VAR              { Var ($1) }            
	|OPEN exp CLOSE  { $2 }     
        |NOT exp         { Neg ($2) }  
        |exp IMPL exp    { BinOp (Impl, $1, $3) }
        |exp AND exp     { BinOp (Conj, $1, $3) }
        |exp OR exp      { BinOp (Disj, $1, $3) }

all_input:
	exps DEQ exp EOF { ($1, $3) }
	|DEQ exp EOF	 { ([], $2) }
exps:
	exp { [$1] }
	|exp COMMA exps	 { $1::$3 }

