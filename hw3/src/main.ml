open Tree;;
open Utils;;
open Evaluator;;
open Buffer;;
open Printf;;
open Proover;;
open Deductor;;
open Proofs;;
open Lemm_proover;;

let (ic, oc) = (open_in "input.txt", open_out "output.txt");;

let (asmps, res) = string_to_tree Parser.all_input (input_line ic);;

let var_to_ind = (Ht.create 12 : (string, int) Ht.t)
let ind_to_var = (Ht.create 12 : (int, string) Ht.t)

let to_proove = (to_right asmps res);;

extract_vars to_proove var_to_ind ind_to_var;; 
let cnt = Ht.length var_to_ind;;
let mask = (Array.make cnt false);;
check to_proove cnt 0 mask ic oc var_to_ind;;

let mask = (Array.make cnt false);;

let get_var i e = begin
	let var_name = Ht.find ind_to_var i in 
	if (e) then Var (var_name) else Neg (Var (var_name))
end
;;

let rec mask_to_ass mask ind sz = 
	if (ind = sz) then (get_var ind mask.(ind))::[]
	else (get_var ind mask.(ind))::(mask_to_ass mask (ind + 1) sz)
;;

let rec merge_proofs ind cnt var_to_ind = 
	if (ind < cnt) then begin
		let cur_name = Ht.find ind_to_var ind in 
		let cur_var = Var (cur_name) in 

		mask.(ind) <- false;
		let asm_f = mask_to_ass mask 0 ind in 
		let next_f = merge_proofs (ind + 1) cnt var_to_ind in 
		let ded_proof_f = apply_deduction_right asm_f next_f in 

		mask.(ind) <- true;
		let asm_t = mask_to_ass mask 0 ind in 
		let next_t = merge_proofs (ind + 1) cnt var_to_ind in
		let ded_proof_t = apply_deduction_right asm_t next_t in 

		let merged = exclude cur_var to_proove in 

		let c1 = concat_lists ded_proof_f merged in 
		concat_lists ded_proof_t c1
	end
	else begin
		let rev_proof = single_proof_list to_proove mask var_to_ind in 
		List.rev rev_proof
	end
;;

let final_proof = merge_proofs 0 cnt var_to_ind;;

let asmps_string = tree_list_to_string_list asmps;;

fprintf oc "%s|-" (String.concat "," asmps_string);;
print_expr res oc;;
print_list final_proof oc;;

let rec remove_asmp exp cnt = 
	if (cnt = 0) then fprintf oc "%s\n" (string_of_expression exp)
	else 
		match exp with
		| BinOp(Impl, l, r) -> begin
			fprintf oc "%s\n" (string_of_expression exp);
			fprintf oc "%s\n" (string_of_expression l);
			remove_asmp r (cnt - 1)
		end
		| _ -> exit 1337
;;

remove_asmp to_proove (List.length asmps);;

close_out oc;
close_in ic;
