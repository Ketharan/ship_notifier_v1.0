import ballerina/io;
import ballerina/mysql;
import ballerina/http;

endpoint mysql:Client testDB {
   host: "localhost",
   port: 3306,
   name: "shipNote",
   username: "root",
   password: "",
   poolOptions: { maximumPoolSize: 5 },
   dbOptions: { useSSL: false }
};

endpoint http:Listener listener {
    port:9090
};

type Order record {
    int id,
    string productname,
    string mobilenumber,
    string username,
    string status,
};










// Calculator REST service
@http:ServiceConfig { basePath: "/calculator" }
service<http:Service> calculator bind listener {

    // Resource that handles the HTTP POST requests that are directed to
    // the path `/operation` to execute a given calculate operation
    // Sample requests for add operation in JSON format
    // `{ "a": 10, "b":  200, "operation": "add"}`
    // `{ "a": 10, "b":  20.0, "operation": "+"}`

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/operation"
    }

    documentation {
       A resource is an invokable API method
       Accessible at '/hello/sayHello
       'caller' is the client invoking this resource 

       P{{caller}} Server Connector
       P{{req}} Request
    }

    executeOperation(endpoint caller, http:Request req) {
        
        json operationReq = check req.getJsonPayload();
        string username = operationReq.username.toString();
	    string mobilenumber = operationReq.mobilenumber.toString();
	    string productname  = operationReq.productname.toString();
        
        //sentNotification();
        var ret = testDB->update("INSERT INTO `orderdetails` (`id`, `productname`, `mobilenumber`, `username`) VALUES (NULL,?,?,?)",productname,mobilenumber,username);

        http:Response response = new;

        response.setTextPayload("ID:"  +  "\n");

        
       
        //match ret {
        	//int retInt => io:println("Insert to student table with no parameters" + " status: " + retInt);
        	//error e => io:println("Insert to student table with no parameters" + " failed: " + e.message);
        //}
        //testDB.stop();

        
    	//handleUpdate(ret, "Insert to student table with no parameters");

         _ = caller -> respond(response);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/sentvals"
    }

    returndata(endpoint caller, http:Request req) {
        
        json operationReq = check req.getJsonPayload();
        table<Order> dt;
        var selectRet = testDB->select("SELECT * FROM orderdetails",Order,
        loadToMemory = true);
        match selectRet {
            table tableReturned => dt = tableReturned;
            error e => io:println("Select data from student table failed: "
                               + e.message);
        }


        
        //var selectRet = testDB->select("SELECT * FROM orderdetails", ());
        //table dt;
       //match selectRet {
          //  table tableReturned => dt = tableReturned;
          //  error e => io:println("Select data from student table failed: "
         //                      + e.message);
       // }

        string reply = "";
        foreach row in dt {
            //io:println("Student:" + row.id + "|" + row.username + "|" + row.mobilenumber);
            reply += row.username + "@";
        }

        reply += "&";

        foreach row in dt {
            //io:println("Student:" + row.id + "|" + row.username + "|" + row.mobilenumber);
            reply += row.mobilenumber + "@";
        }

        reply += "&";

        foreach row in dt {
            //io:println("Student:" + row.id + "|" + row.username + "|" + row.mobilenumber);
            reply += row.status + "@";
        }

        //var jsonConversionRet = <json>dt;

        http:Response response = new;
        
        //match jsonConversionRet {
           // json jsonRes => {
          //      io:print("JSON: ");
          //      io:println(io:sprintf("%s", jsonRes));
         //       response.setJsonPayload(jsonRes);
          //  }
          //  error e => io:println("Error in table to json conversion");
        //}

        
        response.setTextPayload(reply);
        

        // Send response to the client.
        _ = caller->respond(response);

        
       
        //match ret {
        	//int retInt => io:println("Insert to student table with no parameters" + " status: " + retInt);
        	//error e => io:println("Insert to student table with no parameters" + " failed: " + e.message);
        //}
        //testDB.stop();

        
    	//handleUpdate(ret, "Insert to student table with no parameters");

         _ = caller -> respond(response);
    }


    @http:ResourceConfig {
        methods: ["POST"],
        path: "/update"
    }

    update(endpoint caller, http:Request req) {
        
        json operationReq = check req.getJsonPayload();
        string username = operationReq.username.toString();
	    string mobilenumber = operationReq.mobilenumber.toString();
	    string productname  = operationReq.productname.toString();
        string status = operationReq.status.toString();

        
        
        sentNotification(status,mobilenumber);

        var ret = testDB->update("UPDATE `orderdetails` SET `status` = ? WHERE `orderdetails`.`username` = ?",status,username);

        //var ret = testDB->update("INSERT INTO `orderdetails` (`id`, `productname`, `mobilenumber`, `username`) VALUES (NULL,?,?,?)",productname,mobilenumber,username);

        http:Response response = new;

        response.setTextPayload("ID : "  + status +    "\n" + username);

        
       
        match ret {
        	int retInt => io:println("Insert to student table with no parameters" + " status: " + retInt);
        	error e => io:println("Insert to student table with no parameters" + " failed: " + e.message);
        }
        //testDB.stop();

        
    	//handleUpdate(ret, "Insert to student table with no parameters");

         _ = caller -> respond(response);
    }

    
}




