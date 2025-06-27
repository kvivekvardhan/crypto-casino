// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string public message = "Hello, SOC"; 
    // even though message is set as "Hello, SOC" , constructor sets the message 
    // just like how every other high level language works

    constructor(){
        message = "Hello, BlockChain World!";
    }

    function getMessage() public view returns (string memory){
        return message;
    }

    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
}
