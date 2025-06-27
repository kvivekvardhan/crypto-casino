// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint public count; // state variables (persist between transactions)

    // View function to read count
    function getCount() public view returns (uint) {
        return count;
    }

    // Increment count
    function incrementCount() public {
        count++;
    }

    // Decrement count with safety check
    function decrementCount() public {
        require(count > 0, "Count cannot be negative"); // require is used to validate conditions
        // if the condition is not met, the transaction will revert and the state will not be changed
        count--;
    }
}
