open Login ;;

let infoSlow =
    let body = Lwt_main.run (getData
        "https://roboats.virtualregatta.com/api/infos/slow"
    ) in
    print_endline ("Received body\n" ^ body) ;;



let infoFast =
    let body = Lwt_main.run (getData
        "https://roboats.virtualregatta.com/api/infos/fast"
    ) in
    print_endline ("Received body\n" ^ body) ;;


let boatAction =
    let content = "{\n    \"tsLegStart\": 1640010600000,\n    \"actions\" : [\n
    {\n            \"type\": \"heading\",\n            \"values\" : {\n
    \"deg\": 20,\n                \"autoTwa\": false\n            }\n
    \n        }\n    ]\n}" in
    let body = Lwt_main.run (putData
        "https://roboats.virtualregatta.com/api/boat/actions"
        content
    ) in
    print_endline ("Recived body\n" ^ body ) ;;

