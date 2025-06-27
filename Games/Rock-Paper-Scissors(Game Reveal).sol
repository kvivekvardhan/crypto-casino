// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// started with the code of initial rock paper scissors
contract RockPaperScissors{

    address public manager;
    constructor(){
        manager = msg.sender; 
        stage = Stage.Join;
    }

    modifier onlyManager(){
        require(msg.sender == manager,"Only manager has access to this");
        _;
    }

    address public player1;
    address public player2;

    uint public entryFee = 0.001 ether;

    enum Stage {Join , Commit , Reveal , Finished }
    Stage public stage; // what is this line doing ?

    mapping(address => bytes32) public commitments;
    mapping(address => uint8) public revealedMoves;
    mapping(address => bool) public revealed;

    event GameStageChanged(Stage newStage);
    event PlayerCommitted(address player);
    event PlayerRevealed(address player,uint8 move);
    event GameResult(address winner,string result);


    modifier atStage(Stage _stage) {
        require(stage == _stage,"Invalid game stage for this action");
        _;
    }

    modifier onlyPlayers(){
        require(msg.sender == player1 || msg.sender == player2,"Not a player");
        _;
    }

    // external only allows referencing the function from outside not within the script
    // public would set it to both internal and external
    function joinGame() external payable atStage(Stage.Join) {
        require(msg.value == entryFee,"Must pay entry fee");
        if(player1 == address(0)){
            player1 = msg.sender;
        } else if(player2 == address(0)){
            require(msg.sender != player1,"Player already joined"); 
            player2 = msg.sender;
            stage = Stage.Commit;
            emit GameStageChanged(stage);
        } else {
            revert("Game full"); 
        }
    }

    // Commit Phase
    function commitMove(bytes32 commitment) external atStage(Stage.Commit) onlyPlayers {
        require(commitments[msg.sender] == 0,"Already Committed");
        commitments[msg.sender] = commitment;
        emit PlayerCommitted(msg.sender);

        if(commitments[player1] != 0 && commitments[player2] != 0){
            stage = Stage.Reveal;
            emit GameStageChanged(stage);
        }
    }

    // Reveal Phase
    // So the players reveal their moves after the commitment is done along with their salt
    function revealMove(uint8 move,string memory salt) external atStage(Stage.Reveal) onlyPlayers {
        require(!revealed[msg.sender],"Already revealed");
        require(move <= 2,"Invalid move"); 

        bytes32 expectedHash = keccak256(abi.encodePacked(move,salt));
        require(expectedHash == commitments[msg.sender],"Commitment does not match");

        revealedMoves[msg.sender] = move;
        revealed[msg.sender] = true;
        emit PlayerRevealed(msg.sender, move);

        if(revealed[player1] && revealed[player2]){
            decideWinner();
        }
    }

    function decideWinner() private {
        uint8 move1 = revealedMoves[player1];
        uint8 move2 = revealedMoves[player2];

        address winner;
        string memory result;

        if(move1 == move2){
            payable(player1).transfer(entryFee);
            payable(player2).transfer(entryFee);
            result = "Draw, Funds refunded";
        } else if ((move1 + 1) % 3 == move2){
            winner = player2;
            payable(player2).transfer(address(this).balance);
            result = "Player 2, Wins!!";
        } else {
            winner = player1;
            payable(player1).transfer(address(this).balance);
            result = "Player 1, Wins!!";
        }

        emit GameResult( winner, result);
        stage = Stage.Finished;
        emit GameStageChanged(stage);
    }

    function getCurrentStage() external view returns (string memory) {
        if(stage == Stage.Join) return "Join";
        if(stage == Stage.Commit) return "Commit";
        if(stage == Stage.Reveal) return "Reveal";
        return "Finished";
    }

    function resetGame() external onlyManager atStage(Stage.Finished) {     
        delete commitments[player1];
        delete commitments[player2];
        delete revealedMoves[player1];
        delete revealedMoves[player2];
        delete revealed[player1];
        delete revealed[player2];

        player1 = address(0);
        player2 = address(0);
        stage = Stage.Join;
        emit GameStageChanged(stage);
    }

}