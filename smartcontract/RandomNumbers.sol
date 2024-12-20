// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract RandomNumbers {
    address public owner;
    struct Player {
        uint256 deposit;
        uint256 playerid;
        uint256 totalwins;
        uint256 totallosts;
        uint256 betamount;
        bool verdict;
    }
    mapping(address => Player) private players;
    uint256 public moneypool;
    uint256 public playerId;

    constructor() {
        owner = msg.sender;
    }

    event amountdeposit(uint256 deposit, uint256 playerid);
    event AmountWithdraw(uint256 _amount, address user);
    event BetAmount(uint256 _amount, address user, uint256 playerId);

    function DepositAmount() public payable {
        require(msg.value > 0, "invalid amount");
        playerId++;
        moneypool += msg.value;
        players[msg.sender].deposit += msg.value;
        players[msg.sender].playerid = playerId;
        emit amountdeposit(msg.value, playerId);
    }

    function generateRandomNumber() private view returns (uint256) {
        uint256 randomHash = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao))
        );

        uint256 randomNumber = (randomHash % 50) + 1;
        return randomNumber;
    }

    function Withdraw(uint256 _amount) public {
        require(_amount <= players[msg.sender].deposit, "invalid amount");
        players[msg.sender].deposit -= _amount;
        payable(msg.sender).transfer(_amount);
        emit AmountWithdraw(_amount, msg.sender);
    }

    function placebet(uint256 _amount) public {
        require(_amount > 0, "invalid amount");
        players[msg.sender].betamount = _amount;
        players[msg.sender].deposit -= _amount;
        emit BetAmount(_amount, msg.sender, players[msg.sender].playerid);
    }

    function generateNumber(uint256 _number) public {
        require(players[msg.sender].betamount > 0, "place bet first fella");
        uint256 dx = generateRandomNumber();
        if (_number == dx) {
            players[msg.sender].deposit += ((players[msg.sender].betamount) +
                players[msg.sender].betamount /
                5);
                players[msg.sender].totalwins++;
            players[msg.sender].betamount = 0;
        } else {
            players[msg.sender].betamount = 0;
             players[msg.sender].totallosts++;
        }
    }

    function getPlayer()
        public
        view
        returns (
            uint256 deposit,
            uint256 userId,
            uint256 betamount,
            uint256 totalwins,
            uint256 totallosts,
            bool verdict
        )
    {
        Player memory player = players[msg.sender];
        return (
            player.deposit,
            player.playerid,
            player.betamount,
            player.totalwins,
            player.totallosts,
            player.verdict
        );
    }
    
}
