open Lemm_proover;;
open Proofs;;
open Evaluator;;
open Tree;;
open Utils;;

let get_evaluated expr mask var_to_ind = 
	if (eval_expr expr mask var_to_ind) then expr else Neg (expr)
;;

let rec single_proof_list expr mask var_to_ind = 

	let bin_proof l r = begin
		let l_eval = (get_evaluated l mask var_to_ind) in
		let r_eval = (get_evaluated r mask var_to_ind) in

		let l_proof = (single_proof_list l_eval mask var_to_ind) in
		let r_proof = (single_proof_list r_eval mask var_to_ind) in

		let proof_string = get_bin_proof l_eval r_eval expr in 
		let proof_list = split proof_string "\n" in 

		let proof_rev = List.rev proof_list in

		let c1 = concat_lists proof_rev r_proof in
		concat_lists c1 l_proof
	end in

	match expr with
	| Var v	-> v::[]
	| Neg(Var v) -> ("(!" ^ v ^ ")")::[]
	| Neg(BinOp(op, l, r)) -> bin_proof l r	 
	| BinOp(op, l, r)	-> bin_proof l r
	| Neg(Neg (t)) -> begin
		let t_proof = single_proof_list t mask var_to_ind in
		let neg_neg_string = add_double_neg t in 
		let neg_neg_list = split neg_neg_string "\n" in 
		concat_lists (List.rev neg_neg_list) t_proof
	end
;;
