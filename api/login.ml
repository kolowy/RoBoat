open Lwt
open Cohttp
open Cohttp_lwt_unix

let token = ref "";;


(* post request :
    url : url
    content : content to post
    return (body, headers, status code) *)
let reqBody url content = 
    let uri = Uri.of_string url in
    let headers = Header.init ()
        |> fun h -> Header.add h "Content-Type" "application/json"
    in
    let body = Cohttp_lwt.Body.of_string content in
        Client.post ~headers ~body uri >>= fun (resp, body) ->
        let code = resp |> Response.status |> Code.code_of_status in
        body |> Cohttp_lwt.Body.to_string >|= fun body ->
            (body, resp |> Response.headers |> Header.to_list, code);; 



(* load a file : 
    name : name of the file
    return all the file *)
let load name =
    let ic = open_in name in
    let try_read () =
        try Some ( input_line ic ) with End_of_file -> None in
    let rec loop () = match try_read () with
        | Some s -> s ^(loop())
        | None -> ""
    in loop () ;;


(* login function
    change the token send to request *)
let login =
    let content = load "api/login.config" in
    let (_, resp, _) = Lwt_main.run (reqBody
        "https://roboats.virtualregatta.com/api/login"
        content
    ) in
    let rec loop = function
        | [] -> ""
        | ("Token", token)::_ | ("token", token)::_ -> token 
        | (_, _)::tail -> loop tail
    in
        token := (loop resp);;


(* get request while (403) ; login ; recursif  :
    url : url
    return the body of the request *)
let rec getData url =
    let headers = Header.init ()
        |> fun h -> Header.add h "Token" !token in
    Client.get ~headers (Uri.of_string (url)) >>= fun (resp, body) ->
        let code = resp |> Response.status |> Code.code_of_status in
        match code with
            | 403 -> login ; getData url
            | _ -> body |> Cohttp_lwt.Body.to_string >|= fun body -> body ;;


(* put request; while (403) ; login ; recursif :
    url : url
    return the body of the request *)
let rec putData url content =
    let headers = Header.init ()
        |> fun h -> Header.add h "Token" !token
        |> fun h -> Header.add h "Content-Type" "application/json"
    in
    let body = Cohttp_lwt.Body.of_string content in
    let uri = Uri.of_string url in
    Client.call ~headers ~body `PUT uri >>= fun (resp, body) ->
        let code = resp |> Response.status |> Code.code_of_status in
        match code with
            | 403 -> login ; putData url content
            | _ -> body |> Cohttp_lwt.Body.to_string >|= fun body -> body ;;


