// SPDX-License-Identifier : MIT
contract BlockChain{
    uint public count; // state variables (persist between transactions)
    address public owner;

    // functions 
    // view(read BlockChain state variables)
    // pure(pure logic , no read/write blockchain state variables)
    // payable(accepts ether)
    // public(can be called from outside the contract) visible to everyone
    // private(only visible to the contract itself)

    function getCount() public view returns (uint) {
        return count;
    }   

    function incrementCount() public {
        count++;
    }

    function decrementCount() public {
        require(count > 0, "Count cannot be negative"); // require is used to validate conditions
        // if the condition is not met, the transaction will revert and the state will not be changed
        count--;
    }

    uint public balance;
    uint public msg;

    mapping(address => uint) public balances; // mapping is like a dictionary, it maps an address to a uint
    address[] public users; // array of addresses

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _; // this is where the function body will be executed
    }

    function withDraw() public onlyOwner {
        // this function can only be called by the owner of the contract
        // the modifier onlyOwner will check if the msg.sender is the owner
        // if not, it will revert the transaction
        // _; will execute the function body after the modifier checks
        payable(msg.sender).transfer(address(this).balance); // transfer the balance of the contract to the owner
    }

    event Deposited(address indexed sender, uint amount); // event to log deposits

    function deposit(uint amount) public payable {
        require(amount > 0, "Amount must be greater than 0"); // check if the amount is greater than 0
        balances[msg.sender] += amount; // add the amount to the sender's balance
        users.push(msg.sender); // add the sender to the users array
        emit Deposited(msg.sender, amount); // emit the Deposited event
    }

    constructor() {
        owner = msg.sender; // set the owner of the contract to the address that deployed it
        count = 0; // initialize count to 0
    }


    function deposit() public payable {
        // this function allows the contract to accept ether
        // the msg.value is the amount of ether sent with the transaction
        require(msg.value > 0, "You must send some ether"); // observe that msg need not be declared it will be carried on with every contract that you deploy
    }

    function withdraw(uint amount) public {
        require(msg.sender == owner, "Only the owner can withdraw"); // only the owner can withdraw
        require(address(this).balance >= amount, "Insufficient balance"); // check if the contract has enough balance
        payable(msg.sender).transfer(amount); // transfer the amount to the owner
    }

    function getBalance() public view returns (uint) {
        return address(this).balance; // returns the balance of the contract
    }


}

