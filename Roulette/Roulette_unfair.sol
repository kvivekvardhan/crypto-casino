// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UnfairRouletteGame {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function spinWheel() external payable {
        require(msg.value == 0.01 ether, "Bet must be exactly 0.01 ETH");

        // Same 1 in 38 chance
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 38;

        if (random == 0) {
            // House edge: reduce payout to 35x (instead of 38x)
            payable(msg.sender).transfer(0.35 ether);
        }
        // else: lose
    }

    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
