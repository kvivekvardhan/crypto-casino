Solidity Notes:

- functions:
    - view (read state variables)
    - pure (no read/write, pure logic)
    - payable (accepts ether)
    - public (visible to all)
    - private (only within contract)

- require:
    - Used to validate conditions
    - If condition fails, transaction reverts and state doesn’t change

- msg.sender:
    - Automatically available
    - Carries the sender address in every function call

- address(this).balance:
    - Gives current contract balance

- Mappings & Arrays:
    - mapping(address => uint) public balances;
    - address[] public users;

- Modifiers:
    - Customizable reusable checks like onlyOwner()

- Events:
    - Used to log data like deposits for off-chain tracking

