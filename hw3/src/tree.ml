type bin_op = Conj | Disj | Impl;;

type tree = 
	Var of string | 
	Neg of tree | 
	BinOp of bin_op * tree * tree;;
