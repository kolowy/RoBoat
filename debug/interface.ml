open Graphics;;

(* Debug map *)

(*
    Draw a squared tile on the map. Requires an open window 
    :param x, y: coordinates of the tile (int)
    :param size: size in pixel of the tile (int)
    :param color: color of the tile:
        - 0 for water
        - 1 for land
        - 2 for mountains 
    *)
let draw_tile x y size color = (match color with
    | 0 -> set_color (rgb 0 0 255)
    | 1 -> set_color (rgb 100 200 0)
    | 2 -> set_color (rgb 200 100 0)
    | _ -> ())
    ; fill_rect x y size size;;

(* Debug AI *)

(*
    Draw a graph on the screen. Requires an open window
    :param range: max x and y value (int * int)
    *)
let draw_graph range =
    let (x, y) = range in
    let size = 760 / y in
    set_line_width 2;
    moveto 20 20; lineto (20 + size * x) 20; 
    moveto 20 20; lineto 20 (20 + size * y);;

(*
    Add data on a graph. Requires an open window and a graph
    :param x, y: position of the dot (int)
    :param range: max x and y value of the graph (int * int)
    *)
let add_data x y range = 
    let (rx, ry) = range in
    let size = 760.0 /. float_of_int ry in
    set_color blue;
    fill_circle (20 + int_of_float (x *. size)) 
        (20 + int_of_float (y *. size)) 5;;

(*
    Draw the prediction line. Requires an open window and a graph
    :param b: bias (float)
    :param w: weight. works for data with only 1 entry (float)
    :param range: max x and y value of the graph (int * int)
    *)
let draw_predict b w range =
    let (x, y) = range in
    let size = 760.0 /. float_of_int y in
    let py = b +. w *. float_of_int x in
    set_color red;
    moveto 20 (20 + int_of_float (b *. size));
    lineto (20 + int_of_float (size *. py)) 
        (20 + int_of_float (float_of_int x *. size));;

(* Window *)

(*
    Open a new graphics window
    *)
let rec window () =
    open_graph " 1200x800";;
(*
    Run event loop. Must be called after window creation 
    *)
let rec main_loop () =
    let event = wait_next_event [Key_pressed] in
    if event.key == 'q' then exit 0
    else print_char event.key; print_newline (); main_loop ();;
