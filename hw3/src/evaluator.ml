open Tree;;
open Printf;;

module Ht = Hashtbl

let rec extract_vars expr var_to_ind ind_to_var = 
	match expr with
	| Var v -> if (not (Ht.mem var_to_ind v)) then begin
		let ind = Ht.length var_to_ind in
		Ht.add var_to_ind v ind;
		Ht.add ind_to_var ind v;
	end
	| Neg(t) -> extract_vars t var_to_ind ind_to_var
	| BinOp(op, l, r)	-> begin
		extract_vars l var_to_ind ind_to_var;
		extract_vars r var_to_ind ind_to_var;
	end
;;

let eval_op op lv rv = 
	match op with
	| Conj -> lv && rv
	| Disj -> lv || rv
	| Impl -> (not lv) || rv
;;

let rec eval_expr expr mask var_to_ind = 
	match expr with
	| Var v -> mask.(Ht.find var_to_ind v)
	| Neg(t) -> not (eval_expr t mask var_to_ind)
	| BinOp(op, l, r) -> begin
		let lv = eval_expr l mask var_to_ind in 
		let rv = eval_expr r mask var_to_ind in 
		eval_op op lv rv
	end
;;

let rec check expr cnt ind mask ic oc var_to_ind =
	if (ind < cnt) then begin
		mask.(ind) <- false;
		check expr cnt (ind + 1) mask ic oc var_to_ind;
		mask.(ind) <- true;
		check expr cnt (ind + 1) mask ic oc var_to_ind;
	end
	else begin
		if (not (eval_expr expr mask var_to_ind)) then begin
			fprintf oc "%s" "Высказывание ложно при ";
			
			let lst : (string) list ref = ref [] in
	      	let fnc name index = begin 
	      		lst := (name ^ "=" ^ (if (mask.(index)) then "И" else "Л"))::(!lst)
	      	end in 
	      	Ht.iter fnc var_to_ind;
	      	let res = String.concat ", " !lst in

			fprintf oc "%s\n" res;
			close_out oc;
			close_in ic;
			exit 0;
		end
	end
;;

