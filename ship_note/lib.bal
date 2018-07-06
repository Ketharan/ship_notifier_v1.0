
function sentNotification(string status, string mobile){
    http:Request req = new;
    string mess;
    if (status == "Delivered"){
        mess = "Dear customer, your order has been delivered.";
    }else{
        mess = "Dear customer, your order is being in " + status;
    }

    
    json jsonMsg = {"recipient":
    {"phone_number":mobile},
     "message":{"text":mess}
     };

    
    req.setJsonPayload(jsonMsg);

    var response = clientEndpoint->post("/v2.6/me/messages?access_token=EAAGHWrpm5lUBAAcCeD8C6NFfdRYT2ZC6aAZBZBoZBeHZC7ytDyWIZAEFJdIY0nxTbWY7GkpYyLb2MZBmULNRb1lX9ZANTaYQsSy7Qg4tXRY5xxX0yALw1gyMadKkvAGt2bmUMUHntIsXWwad0BcIomu3GJYBDKmRzULLJtcBqMqXWgZDZD", req);
    match response {
        http:Response resp => {
            var msg = resp.getJsonPayload();
            match msg {
                string m => {
                    io:println(m);
                }
                json jsonPayload => {
                    string resultMessage = "Addition result " + jsonPayload["message_id"].toString();
                    io:println(resultMessage);
                }
                error err => {
                    log:printError(err.message, err = err);
                }
                
            }
        }
        error err => { log:printError(err.message, err = err); }
    }
}


