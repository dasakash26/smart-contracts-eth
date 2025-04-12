// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Will{
    address private owner;
    uint private lastPing;
    uint private coolDownPeriod;

    mapping (address => uint) public recipient;

    constructor (uint _coolDownPeriod) payable {
        owner = msg.sender;
        lastPing = block.timestamp;
        coolDownPeriod = _coolDownPeriod;
        recipient[msg.sender] = 100;
    }

    function deposit() public payable {
        
    }

    function getBalance() public view returns(uint) {
    return address(this).balance;
    }

    function setRecipient(address _recipient, uint percentOwnership) public ownerOnly {
        require(percentOwnership>0 && percentOwnership<=recipient[owner], "Given amount is not valid.");
        recipient[owner]-=  percentOwnership;
        recipient[_recipient] = percentOwnership;
    }

    function timeLeft() public view returns(uint _timeLeft) {
        return coolDownPeriod - (block.timestamp - lastPing);
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function ping() public ownerOnly {
        lastPing = block.timestamp;
    }
    
    modifier checkTime() {
       require(block.timestamp>=lastPing+coolDownPeriod,"Can't get token during cool down!!");
       _;
    }

    function claim() public checkTime {
        uint amount = (recipient[msg.sender]* address(this).balance)/100;
        recipient[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}