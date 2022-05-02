open Graphics;;

open_graph " 1200x800";; 

let draw_tile x y size color = (match color with
    | 0 -> set_color (rgb 0 0 255)
    | 1 -> set_color (rgb 100 200 0)
    | 2 -> set_color (rgb 200 100 0))
    ; fill_rect x y size size;;

let rec loop () =
    let event = wait_next_event [Key_pressed] in
    if event.key == 'q' then exit 0
    else print_char event.key; print_newline (); loop ();;

let () = loop ();;
