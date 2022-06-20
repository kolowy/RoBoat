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
