// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RockPaperScissors{

    // There's one problem in this that when you make the player's move public then the second player can see the move and can clearly make a move such that he wins this is literal cheating so we use commit reveal mechanism which clearly removes the values
    address public manager;

    constructor(){
        manager = msg.sender;
    }

    modifier onlyManager(){
        require(msg.sender == manager,"Only manager can access this");
        _;
    }

    address public player1;
    address public player2;

    uint8 public movePlayer1;
    uint8 public movePlayer2;

    bool public player1Played;
    bool public player2Played;

    uint public entryFee = 0.001 ether;

    enum Move {Rock , Paper , Scissors }
    event GameJoined(address player);
    event MoveSubmitted(address player,uint8 move);
    event GameResult(address winner,string result);

    modifier onlyPlayers(){
        require(msg.sender == player1 || msg.sender == player2,"Not a player");
        _;
    }

    function joinGame() public payable {
        require(msg.value == entryFee,"Must pay entry fee");
        if(player1 == address(0)){
            player1 = msg.sender;
            emit GameJoined(msg.sender);
        } else if(player2 == address(0)){
            require(msg.sender != player1,"Player already joined"); // Good bugfound player1 can play against player1 but no use actually until some extra reward token is used
            player2 = msg.sender;
            emit GameJoined(msg.sender);
        } else {
            revert("Game full"); // what does revert does ?? undo the changes and go back to the previous state
        }
    }

    function play(uint8 move) public onlyPlayers {
        require(move <= 2,"Invalid Move");

        if(msg.sender == player1){
            // even if two players are same if they register using same addresses then he will not be able to make his next move because once he makes the first move then that condition matches
            // but how do we make sure the players playing are not related to each other ? or are the same ? maybe same person with two wallets
            require(!player1Played,"Already Played");
            movePlayer1 = move;
            player1Played = true;
        } else if (msg.sender == player2) {
            require(!player2Played,"Already Played");
            movePlayer2 = move;
            player2Played = true;
        }
        // Not required onlyPlayers takes care of it
        // } else {
        //     revert("You are not allowed to play");
        // }
        
        emit MoveSubmitted(msg.sender, move);

        if(player1Played && player2Played){
            decideWinner();
        }
    }

    function decideWinner() public onlyManager {
        address winner;
        string memory result;
        if(movePlayer1 == movePlayer2){
            payable(player1).transfer(entryFee);
            payable(player2).transfer(entryFee);
            result = "Draw , funds refunded";
        } else if((movePlayer1 + 1) % 3 == movePlayer2){
            winner = player2;
            payable(player2).transfer(address(this).balance);
            result = "Player 2 Wins !!";
        } else {
            winner = player1;
            payable(player1).transfer(address(this).balance);
            result = "Player 1 Wins !!";
        }

        emit GameResult(winner, result);

        resetGame();
    }

    function resetGame() private { 
        player1 = address(0);
        player2 = address(0);
        player1Played = false;
        player2Played = false;
    }

}