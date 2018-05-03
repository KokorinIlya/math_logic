open Tree;;
open Utils;;

module Ht = Hashtbl

let apply_deduction_right asmps proof = begin
	let ass_set	= (Ht.create 2048 : (tree, int) Ht.t) in

	let if_ass expr = 
		if (Ht.mem ass_set expr) then (Ht.find ass_set expr) else -1
	in

	let first_index = (Ht.create 2048 : (tree, int) Ht.t) in
	let can_be_proved_by_mp = (Ht.create 2048 : (tree, (tree * int) list) Ht.t) in
	let proved_set = (Ht.create 2048 : (tree, int) Ht.t) in

	let upd_mp expr cur_index 
		= match expr with
	| BinOp (Impl, a, b) -> if (Ht.mem first_index a) 
		then begin
		let expr_ind = Ht.find first_index a in 
		Ht.replace proved_set b expr_ind
	end else begin
		let tpl = (b, cur_index) in
		if (Ht.mem can_be_proved_by_mp a) then begin
			let lst = Ht.find can_be_proved_by_mp a in 
			let new_lst = tpl::lst in 
			Ht.replace can_be_proved_by_mp a new_lst
		end 
		else Ht.add can_be_proved_by_mp a (tpl::[])
	end 
	| _	-> ()
	in

	let rec cut_one lst = 
		match lst with
		| [] -> []
		| x::[] -> []
		| x::y -> x::(cut_one y)
	in

	let rec add_ass_to_map lst cur_index = 
		match lst with
		| [] -> ()
		| x::y -> begin
			Ht.add ass_set x (cur_index + 1);
			add_ass_to_map y (cur_index + 1)
		end
	in 

	let add_all_ass ass_set = 
		if (List.length ass_set = 1) then List.hd ass_set
		else begin
			let true_assumps = cut_one ass_set in 		 
			add_ass_to_map true_assumps 0;
			List.hd (List.rev ass_set)
		end
	in

	let index_to_tree = (Ht.create 2048 : (int, tree) Ht.t) in

	let alpha = add_all_ass asmps in
	let cur_index = ref 1 in
	let alpha_s = string_of_expression alpha in
	
	let if_ass_or_axiom expr = begin
		let expr_str = (string_of_expression expr) in

		let str1 = expr_str in 
		let str2 = expr_str ^ "->(" ^ alpha_s ^ "->" ^ expr_str ^ ")" in
		let str3 = alpha_s ^ "->" ^ expr_str in 
		str1::str2::str3::[]
	end in

	let process_alpha expr = begin
		let expr_str = (string_of_expression expr) in

		let str1 = expr_str ^ "->(" ^ expr_str ^ "->" ^ expr_str ^ ")" in 
		let str2 = "(" ^ str1 ^ ")->(" ^ str1 ^ "->" ^ expr_str ^ ")->(" ^ expr_str ^ "->" ^ expr_str ^ ")" in 
		let str3 = "(" ^ expr_str ^ "->(" ^ expr_str ^ "->" ^ expr_str ^ ")" ^ "->" ^ expr_str ^ ")->(" ^ expr_str ^ "->" ^ expr_str ^ ")" in 
		let str4 = expr_str ^ "->(" ^ expr_str ^ "->" ^ expr_str ^ ")" ^ "->" ^ expr_str in 
		let str5 = expr_str ^ "->" ^ expr_str in 
		str1::str2::str3::str4::str5::[]
	end in

	let process_mp di = begin
		let dj_s = string_of_expression (Ht.find index_to_tree (Ht.find proved_set di)) in
		let di_s = string_of_expression di in 

		let str1 = "(" ^ alpha_s ^ "->" ^ dj_s ^ ")->(" ^ alpha_s ^ "->" ^ dj_s ^ "->" ^ di_s ^ ")->(" ^ alpha_s ^ "->" ^ di_s ^ ")" in 
		let str2 = "(" ^ alpha_s ^ "->" ^ dj_s ^ "->" ^ di_s ^ ")->(" ^ alpha_s ^ "->" ^ di_s ^ ")" in 
		let str3 = alpha_s ^ "->" ^ di_s in 

		str1::str2::str3::[]
	end in

	let rec replace_after lst = 
		match lst with
		| [] -> ()
		| (e, i)::y -> begin
			Ht.replace proved_set e !cur_index;
			replace_after y 
		end
	in 

	let deduce_one expr = begin
		let res = if (expr = alpha) then process_alpha expr
		else begin 
			let axiom_num = check_ax expr in 

			if (axiom_num > 0) then if_ass_or_axiom expr 
			else begin
				let asmp_num = if_ass expr in 

				if (asmp_num > -1) then if_ass_or_axiom expr else process_mp expr
			end
		end 
		in

		upd_mp expr !cur_index;

		if (Ht.mem can_be_proved_by_mp expr) then begin
			let cur_lst = Ht.find can_be_proved_by_mp expr in 
			replace_after cur_lst;
			Ht.replace can_be_proved_by_mp expr [];
		end;

		Ht.replace first_index expr !cur_index;
		Ht.add index_to_tree !cur_index expr;
		cur_index := !cur_index + 1;
		res
	end in

	let rec get_ans exprs = match exprs with
	| [] -> []
	| x::y	-> begin
		let x_d = deduce_one x in
		concat_lists x_d (get_ans y)
	end;
	in

	get_ans (string_list_to_tree_list proof)
end;;

																								
