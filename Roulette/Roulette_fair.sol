// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FairRouletteGame {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function spinWheel() external payable {
        require(msg.value == 0.01 ether, "Bet must be exactly 0.01 ETH");

        // Fair roulette: 1 in 38 chance to win (European roulette has 37 numbers, American has 38)
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 38;

        if (random == 0) {
            // Fair payout: 38x (true odds)
            payable(msg.sender).transfer(0.38 ether);
        }
        // else: lose
    }

    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}

