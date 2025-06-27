// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Lottery {
    address public manager;
    address[] public players;

    constructor(){
        manager = msg.sender;
    }


    // can have a modifier where only manager can see all of this
    modifier onlyManager(){
        require(msg.sender == manager,"Only manager can call this function");
        _;
    }


    // Push players
    event playerEntered(address indexed players);
    event WinnerPicked(address indexed winner,uint amount);

    function enter() public payable{
        require(msg.value >= 0.01 ether,"Minimum ETH to enter is 0.01");
        players.push(msg.sender);
        emit playerEntered(msg.sender);
    } 

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function random() private view returns (uint) {
        // not a good random function actually because all of these are public and someone can guess it immediately 
        // in real production oracles like chainlink vrf(on chain production) is used or zkSync / Aztec
        return uint(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, players.length, address(this).balance)
                // I tried block.difficulty first assuming the previous ethereum model now they are upgraded to this proof of stake upgrade 
            )
        ) % players.length;
        
    }

    // also this function must be made non Reentrant (made through importing some modules) so that when a winner receives he may not call the function again calling the function again 
    function pickWinner() public onlyManager {
        require(msg.sender == manager,"Only manager can pick winner");
        require(players.length > 0,"No players in the lottery");

        uint index = random();
        address winner = players[index];
        uint prize = address(this).balance;

        (bool success, ) = payable(winner).call{value : prize}(""); // why did we remove transfer here ?
        // call can transfer any amount of gas but transfer has a limit of 2300 gas
        // also if winner is a smart contract then transfer will fail
        require(success,"Transfer failed");

        delete players;
    }

    function getPlayers() public view returns (address[] memory){
        return players;
    }

}