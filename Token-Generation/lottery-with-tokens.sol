// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is ERC20, Ownable {

    address[] public players;
    uint public ENTRY_FEE = 0.01 ether;
    uint public PRIZE_TOKENS = 10000;

    constructor() ERC20("Paisa","P") Ownable(msg.sender) {
        _mint(msg.sender,100000 * 10** decimals()); // decimals() will auto adjust according to the standards
    }

    event PlayerEntered(address indexed player);
    event WinnerPicked(address indexed winner,uint256 ethAmount,uint256 bonusTokens);


    function enter() public payable{
        require(msg.value >= 0.01 ether,"Minimum ETH to enter is 0.01");
        players.push(msg.sender);
        emit PlayerEntered(msg.sender);
    } 

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function random() private view returns (uint) {
        // not a good random function actually because all of these are public and someone can guess it immediately 
        // in real production oracles like chainlink vrf(on chain production) is used or zkSync / Aztec
        return uint(
            keccak256(
                abi.encodePacked(
                    block.timestamp, 
                    block.prevrandao, 
                    players.length, 
                    address(this).balance)
            )
        ) % players.length;
        
    }

    // also this function must be made non Reentrant (made through importing some modules) so that when a winner receives he may not call the function again calling the function again 
    function pickWinner() public onlyOwner {
        require(players.length > 0,"No players in the lottery");

        uint index = random();
        address winner = players[index];
        uint prize = address(this).balance;

        (bool success, ) = payable(winner).call{value : prize}(""); // why did we remove transfer here ?
        // call can transfer any amount of gas but transfer has a limit of 2300 gas
        // also if winner is a smart contract then transfer will fail
        require(success,"Transfer failed");

        _mint(winner,PRIZE_TOKENS);

        emit WinnerPicked(winner,prize,PRIZE_TOKENS);

        delete players;
    }

    function getPlayers() public view returns (address[] memory){
        return players;
    }
}