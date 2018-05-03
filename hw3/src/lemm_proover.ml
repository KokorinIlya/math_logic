open Proofs;;
open Tree;;
open Utils;;

let get_t_t_disj alpha beta = 
	rep_proof alpha beta t_t_disj_s
;;

let get_t_f_disj alpha beta = 
	match beta with 
	| Neg(t) -> rep_proof alpha t t_f_disj_s
;;


let get_f_t_disj alpha beta =
	match alpha with
	| Neg(t) -> rep_proof t beta f_t_disj_s
;;

let get_f_f_neg_disj alpha beta = 
	match (alpha, beta) with
	| (Neg(_alpha), Neg(_beta)) -> rep_proof _alpha _beta f_f_neg_disj_s
;;

let get_t_t_conj alpha beta = 
	rep_proof alpha beta t_t_conj_s
;;


let get_t_f_neg_conj alpha beta = 
	match beta with
	| Neg(t) -> rep_proof alpha t t_f_neg_conj_s
;;

let get_f_t_neg_conj alpha beta = 
	match alpha with 
	| Neg(t) -> rep_proof t beta f_t_neg_conj_s
;;

let get_f_f_neg_conj alpha beta = 
	match (alpha, beta) with
	| (Neg(_alpha), Neg(_beta)) -> rep_proof _alpha _beta f_f_neg_conj_s
;;

let get_t_t_impl alpha beta =
	rep_proof alpha beta t_t_impl_s
;;

let get_t_f_neg_impl alpha beta =
	match beta with
	| Neg(t) -> rep_proof alpha t t_f_neg_impl_s
;;

let get_f_t_impl alpha beta = 
	match alpha with
	| Neg(t) -> rep_proof t beta f_t_impl_s
;;

let get_f_f_impl alpha beta =
	match (alpha, beta) with
	| (Neg(_alpha), Neg(_beta)) -> rep_proof _alpha _beta f_f_impl_s
;;

let get_bin_proof a b expr = match expr with

	(*-----------DISJ-----------*)
	| BinOp(Disj, a_1, b_1) when (a = a_1 && b = b_1) -> get_t_t_disj a b
	| BinOp(Disj, a_1, b_1) when (b = a_1 && a = b_1) -> get_t_t_disj b a

	| BinOp(Disj, a_1, b_1) when (a = a_1 && b = Neg(b_1)) -> get_t_f_disj a b
	| BinOp(Disj, a_1, b_1) when (b = a_1 && a = Neg(b_1)) -> get_t_f_disj b  a

	| BinOp(Disj, a_1, b_1) when (a = Neg(a_1) && b = b_1) -> get_f_t_disj a b
	| BinOp(Disj, a_1, b_1) when (b = Neg(a_1) && a = b_1) -> get_f_t_disj b a

	| Neg(BinOp(Disj, a_1, b_1)) when (a = Neg(a_1) && b = Neg(b_1)) -> get_f_f_neg_disj a b
	| Neg(BinOp(Disj, a_1, b_1)) when (b = Neg(a_1) && a = Neg(b_1)) -> get_f_f_neg_disj b a

	(*-----------CONJ-----------*)

	| BinOp(Conj, a_1, b_1) when (a = a_1 && b = b_1) -> get_t_t_conj a b
	| BinOp(Conj, a_1, b_1) when (b = a_1 && a = b_1) -> get_t_t_conj b a

	| Neg(BinOp(Conj, a_1, b_1)) when (a = a_1 && b = Neg(b_1)) -> get_t_f_neg_conj a b
	| Neg(BinOp(Conj, a_1, b_1)) when (b = a_1 && a = Neg(b_1)) -> get_t_f_neg_conj b a

	| Neg(BinOp(Conj, a_1, b_1)) when (a = Neg(a_1) && b = b_1) -> get_f_t_neg_conj a b
	| Neg(BinOp(Conj, a_1, b_1)) when (b = Neg(a_1) && a = b_1) -> get_f_t_neg_conj b a

	| Neg(BinOp(Conj, a_1, b_1)) when (a = Neg(a_1) && b = Neg(b_1)) -> get_f_f_neg_conj a b
	| Neg(BinOp(Conj, a_1, b_1)) when (b = Neg(a_1) && a = Neg(b_1)) -> get_f_f_neg_conj b a

	(*-----------IMPL-----------*)

	| BinOp(Impl, a_1, b_1) when (a = a_1 && b = b_1) -> get_t_t_impl a b
	| BinOp(Impl, a_1, b_1) when (b = a_1 && a = b_1) -> get_t_t_impl b a

	| Neg(BinOp(Impl, a_1, b_1)) when (a = a_1 && b = Neg(b_1)) -> get_t_f_neg_impl a b
	| Neg(BinOp(Impl, a_1, b_1)) when (b = a_1 && a = Neg(b_1)) -> get_t_f_neg_impl b a

	| BinOp(Impl, a_1, b_1) when (a = Neg(a_1) && b = b_1) -> get_f_t_impl a b
	| BinOp(Impl, a_1, b_1) when (b = Neg(a_1) && a = b_1) -> get_f_t_impl b a

	| BinOp(Impl, a_1, b_1) when (a = Neg(a_1) && b = Neg(b_1)) -> get_f_f_impl a b
	| BinOp(Impl, a_1, b_1) when (b = Neg(a_1) && a = Neg(b_1)) -> get_f_f_impl b a

	| _ -> err_str
;;

let add_double_neg expr = replace "a" (string_of_expression expr) add_double_neg_s;;

let get_contr a b = 
	rep_proof a b contr_s
;;

let a_or_not_a expr =
	let a = Var("a") in
	let not_a = Neg (a) in

	let a_or_not_a = BinOp(Disj, a, Neg(a)) in

	let c1 = get_contr a a_or_not_a in 
	let c2 = get_contr not_a a_or_not_a in 

	let s = "a->(a|!a)\n" ^
	c1 ^
	"\n!(a|!a)->!a\n!a->(a|!a)\n" ^
	c2 ^
	"\n!(a|!a)->!!a\n" ^
	"(!(a|!a)->!a)->(!(a|!a)->!!a)->!!(a|!a)\n" ^
	"(!(a|!a)->!!a)->!!(a|!a)\n!!(a|!a)\n" ^
	"!!(a|!a)->(a|!a)\n(a|!a)" in

	replace "a" (string_of_expression expr) s
;;

let exclude a f = 
	let a_s = (string_of_expression a) in
	let na_s = "!(" ^ a_s ^ ")" in
	let f_s = (string_of_expression f) in
	let tmp = (a_or_not_a a) ^ "\n" ^
	("(" ^ a_s ^ "->" ^ f_s ^ ")->(" ^ na_s ^ "->" ^ f_s ^ ")->((" ^ a_s ^ "|" ^ na_s ^ ")->" ^ f_s ^ ")\n") ^
	("(" ^ na_s ^ "->" ^ f_s ^ ")->((" ^ a_s ^ "|" ^ na_s ^ ")->" ^ f_s ^ ")\n") ^ 
	("(" ^ a_s ^ "|" ^ na_s ^ ")->" ^ f_s ^ "\n") ^ f_s in
	split tmp "\n"
;;