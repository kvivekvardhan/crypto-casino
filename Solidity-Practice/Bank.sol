// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public owner;
    uint public balance; // Not really needed since address(this).balance is always accessible

    mapping(address => uint) public balances; // mapping is like a dictionary, it maps an address to a uint
    address[] public users; // array of addresses

    event Deposited(address indexed sender, uint amount); // event to log deposits

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _; // this is where the function body will be executed
    }

    constructor() {
        owner = msg.sender; // set the owner of the contract to the address that deployed it
    }

    // Deposit with balance tracking
    function depositWithTracking(uint amount) public payable {
        require(amount > 0, "Amount must be greater than 0"); // check if the amount is greater than 0
        balances[msg.sender] += amount; // add the amount to the sender's balance
        users.push(msg.sender); // add the sender to the users array
        emit Deposited(msg.sender, amount); // emit the Deposited event
    }

    // Basic Ether deposit
    function deposit() public payable {
        // this function allows the contract to accept ether
        // msg.value is the amount of ether sent with the transaction
        require(msg.value > 0, "You must send some ether"); // observe that msg need not be declared it will be carried on with every contract that you deploy
    }

    // Withdraw entire contract balance (only by owner)
    function withDraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance); // transfer the balance of the contract to the owner
    }

    // Withdraw specific amount (only by owner)
    function withdraw(uint amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance"); // check if the contract has enough balance
        payable(msg.sender).transfer(amount); // transfer the amount to the owner
    }

    // Check contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance; // returns the balance of the contract
    }
}
