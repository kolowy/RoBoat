(*
    Calculates the mean (average) of a given list

    param data: data to average (float list)
    returns: mean of the list (float) *)
let mean data =
    let rec get_vals l = match l with
        | [] -> (0.0, 0.0)
        | e::l -> let (c, s) = get_vals l in
            (c +. 1.0, s +. e)
    in let (c, s) = get_vals data in
        s /. c;;

(*
    Calculates the standard deviation (root of variance) of a given list

    param data: used data (float list)
    returns: standard deviation of the list (float) *)
let std data = let m = mean data in
    let rec variance l = match l with
        | [] -> 0.
        | e::l -> let v = variance l in
            v +. (e -. m) *. (e -. m)
    in Float.sqrt(variance data);;

(*
    Scale data using standardization method

    param d: data to be scaled (float)
    param m: mean of the dataset (float)
    param s: standard deviation of the dataset (float)
    returns: data value scaled (float) *)
let scale d m s = (d - m) / s;;
