open Stats;;

Random.self_init ();;

(*
    Initialise random bias and weight values

    param n: number of weights (int)
    returns: a tuple with the bias (float) and the weights (float list)
    *)
let init n =
    let rec loop i = match i with
        | 0 -> []
        | _ -> (Random.float 1.0)::loop (i-1)
    in (Random.float 1.0, loop n);;

(*
    Predict values using y = b + w1*d1 + w2*d2 ...
        with b the bias d1, d2 the different datas in the equations and
        w1, w2 the weights of the according data

    param b: bias (float)
    param x: data. correspond to a line in the data matrix (float list)
    param w: weights, must be same length as data (float list)
    returns: the expected value of y (float)
    *)
let predict b x w =
    let rec loop x w = match x, w with
        | ([], []) -> 0.0
        | ([], _) | (_, []) -> 
                invalid_arg "data and weights must be the same length"
        | (v::x, e::w) -> v *. e +. loop x w
    in b +. loop x w;;

(*
    Predict all values using the predict function

    param b: bias (float)
    param x: list of data line by line. 
        each float in the list is a different data (float list list)
    param w: weights, must be same length as data (float list)
    returns: each expected value (float list)
    *)
let rec predict_y b x w = match x with
    | [] -> []
    | e::x -> (predict b e w)::predict_y b x w;;

(*
    Calculates the cost of current prediction

    param y: current set of value (float list)
    param yp: set of predicted value. 
        Must be same length as y (float list)
    returns: the cost of the predicted value (float)
    *)
let cost y yp = 
    let rec dot y yp = match (y, yp) with
        | ([], []) -> (0.0, 0.0)
        | ([], _) | (_, []) ->
                invalid_arg "y and yp must be of same length"
        | (e1::y, e2::yp) ->
                let (d, l) = dot y yp in
                ((e1 -. e2) *. (e1 -. e2) +. d, l +. 1.0)
    in let (dp, len) = dot y yp in
        dp /. len;;

(*
    Update bias and weigths to reduce cost

    param x: input for prediction. 
        each list correspond to 1 data (float list list)
    param y: real result. Must be of same length as x (float)
    param yp: predicted result. Must be of same length as x (float)
    param b: bias (float)
    param w: weights (float list)
    param lr: learning rate: update step (float)
    returns: a tuple with the new bias (float) and the new weights (float list)
    *)
let update_weight x y yp b w lr =
    let rec dot_p x dy = match (x, dy) with
        | ([], _) | (_, []) -> 0.0
        | (e::x, d::dy) -> e *. d +. dot_p x dy
    in
    let rec get_vals y yp = match (y, yp) with
        | ([], []) -> (0.0, [], 0.0)
        | (_, []) | ([], _) ->
                invalid_arg "y and yp must be of same length"
        | (o::y, op::yp) ->
                let (s, d, l) = get_vals y yp and diff = o -. op in
                (s +. diff, diff::d, l +. 1.0)
    in let (sum, diffs, len) = get_vals y yp in
    let rec get_weights x diffs = match x with
        | [] -> []
        | e::x -> (dot_p e diffs *. 2.0 /. len)::get_weights x diffs
    in
    let db = sum *. 2.0 /. len and dw = get_weights x diffs in
    let rec apply w dw = match (w, dw) with
        | ([], _) | (_, []) -> []
        | (e::w, d::dw) -> (e -. lr *. d)::apply w dw
    in (b -. lr *. db, apply w dw);;

(*
    Takes a data matrix and return a list of each line
    param x: data matrix
    param n: number of entries
    *)
let get_entries x n = 
    let rec init i = match i with
        | 0 -> []
        | i -> []::init (i-1)
    and fill x l = match (x, l) with
        | ([], _) | (_, []) -> []
        | (e::x, li::l) -> (e::li)::fill x l
    and revert l r = match l with
        | [] -> r
        | e::l -> revert l (e::r)
    in let rec loop x = match x with
        | [] -> init n
        | e::x -> fill e (loop x)
    in loop (revert x []);;

(*
    Scale a list of data
    param l: the list to scale
    *)
let scale_l l =
    let m = mean l and s = std l in
    let rec loop l = match l with
        | [] -> []
        | e::l -> (scale e m s)::loop l
    in loop l;;

(*
    Scale a data matrix
    param m: the matrix to scale
    *)
let rec scale_m m = match m with
    | [] -> []
    | e::l -> (scale_l e)::scale_m l;;

(*
    Run the Gradient descent algorithm
    
    param x: list of entry data. each list is a different data (float list list)
    param y: list of all example values in data (float list)
    param alpha: learning rate: update step for weight values (float)
    param it: number of iterations (int)
    returns: a tuple the final bias (float) and weights (float list)
    *)
let gradient_descent x y alpha it =
    let x = scale_m x and y = scale_l y in
    let rec len l = match l with
        | [] -> 0
        | _::l -> len l + 1 
    in let (b, w) = init (len x) in
    let rec loop it = match it with
        | 0 -> (b, w)
        | it -> let (b, w) = loop (it - 1) in
            let yp = predict_y b (get_entries x (len y)) w in
            update_weight x y yp b w alpha
    in loop it;;
