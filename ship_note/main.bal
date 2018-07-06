import ballerina/config;
import ballerina/log;
import ballerina/io;
import ballerina/http;

endpoint http:Client clientEndpoint {
    url: "https://graph.facebook.com"
};

function main(string... args) {

    io:println("welcome");
}






