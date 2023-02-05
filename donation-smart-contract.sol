// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Donors {
    mapping(address => uint) public paymentsOf;
    mapping(address => uint) public donationsBy;
    
    address payable public owner;
    uint public balance;
    uint public withdrawn;
    uint public totalDonations;
    uint public totalWithdrawal;

    event Donation(
        uint id,
        address indexed from,
        uint amount,
        uint timestamp
    );

    event withdrawal(
        uint id,
        address indexed to,
        uint amount,
        uint timestamp
    );

    constructor(){
        owner =payable(msg.sender);
    }

    function donate() payable public {
        require(msg.value > 0, "Insufficient amount!");

        paymentsOf[msg.sender] += msg.value;
        donationsBy[msg.sender] += 1;
        balance += msg.value;
        totalDonations++;

        emit Donation(
            totalDonations,
            msg.sender,
            msg.value,
            block.timestamp
        );
    }

    function withdraw(uint amount) public returns (bool) {
        require(msg.sender == owner, "Unauthorized person");
        require(balance >= amount, "Insufficient balance");

        balance -= amount;
        withdrawn += amount;
        totalWithdrawal++;
        owner.transfer(amount);
    
        emit withdrawal(
            totalWithdrawal,
            owner,
            amount,
            block.timestamp
        );

        return true;
    }
}