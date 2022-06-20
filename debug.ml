open Interface;;
open Regression;;

let (b, w) = init 1;;

let data_x = [1.0; 2.5; 4.0; 3.0; 5.0];;
let data_y = [1.0; 3.0; 3.4; 2.0; 5.0];;

window();;

let range = (6, 6);;
draw_graph range;; 

let rec plot_data x y = match (x, y) with
    | ([], _) | (_, []) -> ()
    | (ex::x, ey::y) -> add_data ex ey range; plot_data x y;;

plot_data data_x data_y;;

let a = match w with
    | [] -> 0.0
    | e::l -> e;;

draw_predict b a range;;

main_loop();;
