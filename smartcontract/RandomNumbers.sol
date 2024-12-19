// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract RandomNumbers {
    address public owner;
    struct Player {
        uint256 deposit;
        uint256 playerid;
        uint256 totalwins;
        uint256 totallosts;
        bool verdict;
    }
    mapping(address => Player) public players;
    uint256 public moneypool;
    uint256 public playerId;

    constructor() {
        owner = msg.sender;
    }

    event amountdeposit(uint256 deposit, uint256 playerid);

    function DepositAmount() public payable {
        require(msg.value > 0, "invalid amount");
        playerId++;
        moneypool+=msg.value;
        players[msg.sender].deposit += msg.value;
        players[msg.sender].playerid = playerId;
        emit amountdeposit(msg.value, playerId);
    }
    function generateRandomNumber() private  view returns (uint) {
        uint randomHash = uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao)));

        uint randomNumber = (randomHash % 50) + 1;
        return randomNumber;
    }
}
