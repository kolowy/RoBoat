open Lwt
open Cohttp
open Cohttp_lwt_unix

(*let getData url =
    Client.get (Uri.of_string (url)) >>= fun (resp, body) ->
        let code = resp |> Response.status |> Code.code_of_status in
        Printf.printf "Response code: %d\n" code;
        Printf.printf "Headers: %s\n" (resp |> Response.headers |>
        Header.to_string);
        body |> Cohttp_lwt.Body.to_string >|= fun body ->
            Printf.printf "Body of length: %d\n" (String.length
        body);
    body;;*)


let reqBody url content = 
    let uri = Uri.of_string url in
    let headers = Header.init ()
        |> fun h -> Header.add h "Content-Type" "application/json"
    in
    let body = Cohttp_lwt.Body.of_string content in
        Client.post ~headers ~body uri >>= fun (resp, body) ->
        let code = resp |> Response.status |> Code.code_of_status in
        Printf.printf "Response code: %d\n" code;
        Printf.printf "Headers: %s\n" (resp |> Response.headers |>
        Header.to_string);
        body |> Cohttp_lwt.Body.to_string >|= fun body ->
            Printf.printf "Body of length: %d\n" (String.length
        body);
    body;; 

let load name =
    let ic = open_in name in
    let try_read () =
        try Some ( input_line ic ) with End_of_file -> None in
    let rec loop () = match try_read () with
        | Some s -> s ^(loop())
        | None -> ""
    in loop () ;;


let () =
    let content = load "api/login.config" in
    let body = Lwt_main.run (reqBody
    "https://roboats.virtualregatta.com/api/login"
    content
    ) in
        print_endline ("Received body\n" ^ body)
