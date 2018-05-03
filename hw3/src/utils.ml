open Tree;;
open Printf;;

let (>>) x f = f x;;

let string_to_tree parser s = s >> Lexing.from_string >> parser Lexer.main;;

let rec concat_lists l1 l2 = 
	match l1 with
	| [] -> l2
	| x::y -> x::(concat_lists y l2)
;;

let split str sep = Str.split (Str.regexp sep) str;;

let string_of_binop op = 
	match op with
	| Conj -> "&"
	| Disj -> "|"
	| Impl -> "->"
;;

let rec string_of_expression exp = 
	match exp with
	| Var v -> v
	| Neg (t) -> begin
		let t_s = string_of_expression t in
		"(!" ^ t_s ^ ")"
	end 
	| BinOp (op, l, r) -> begin
		let left_s = string_of_expression l in 
		let right_s = string_of_expression r in
		let op_string = string_of_binop op in
		"(" ^ left_s ^ op_string ^ right_s ^ ")" 
	end
;;

let replace f r s = 
	Str.global_replace (Str.regexp f) r s

let rep_proof a b s = 
	let a_s = (string_of_expression a) in
	let b_s = (string_of_expression b) in
	let first_replace = replace "a" a_s s in 
	replace "b" b_s first_replace
;;

let rec to_right exprs expr = 
	match exprs with
	| []	-> expr
	| x::y	-> BinOp(Impl, x, (to_right y expr))
;;

let rec print_list lst oc = 
	match lst with
	| [] -> ()
	| x::y -> begin
		fprintf oc "%s\n" x;
		print_list y oc
	end
;;

let print_expr expr oc = begin
	let e_s = string_of_expression expr in 
	fprintf oc "%s\n" e_s
end
;;

let rec string_list_to_tree_list lst = 
	match lst with
	| [] -> []
	| x::y -> (string_to_tree Parser.main x)::(string_list_to_tree_list y)
;;

let rec tree_list_to_string_list lst = 
	match lst with
	| [] -> []
	| x::y -> (string_of_expression x)::(tree_list_to_string_list y)
;;

let check_ax expr =	
	match expr with
	| BinOp (Impl, a_1, BinOp (Impl, b_1, a_2)) when (a_1 = a_2) -> 1

	| BinOp (Impl, BinOp (Impl, a_1, b_1), BinOp (Impl, BinOp (Impl, a_2, BinOp (Impl, b_2, c_1)), BinOp (Impl, a_3, c_2))) when (a_1 = a_2 && a_2 = a_3 && b_1 = b_2 && c_1 = c_2) -> 2
	
	| BinOp (Impl, a_1, BinOp (Impl, b_1, BinOp (Conj, a_2, b_2))) when (a_1 = a_2 && b_1 = b_2) -> 3
	
	| BinOp (Impl, BinOp (Conj, a_1, b_1), a_2) when (a_1 = a_2) -> 4
	
	| BinOp (Impl, BinOp (Conj, a_1, b_1), b_2) when (b_1 = b_2) -> 5

	| BinOp (Impl, a_1, BinOp (Disj, a_2, b_1)) when (a_1 = a_2) -> 6

	| BinOp (Impl, b_1, BinOp (Disj, a_1, b_2)) when (b_1 = b_2) -> 7

	| BinOp (Impl, BinOp (Impl, a_1, c_1), BinOp (Impl, BinOp (Impl, b_1, c_2), BinOp (Impl, BinOp (Disj, a_2, b_2), c_3))) when (a_1 = a_2 && b_1 = b_2 && c_1 = c_2 && c_2 = c_3) -> 8
	
	| BinOp (Impl, BinOp (Impl, a_1, b_1), BinOp (Impl, BinOp(Impl, a_2, Neg (b_2)), Neg (a_3))) when (a_1 = a_2 && a_2 = a_3 && b_1 = b_2) -> 9
	
	| BinOp (Impl, Neg (Neg (a_1)), a_2) when (a_1 = a_2) -> 10
	| _ -> 0
;;