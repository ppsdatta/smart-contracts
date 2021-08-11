// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.5.0 <=0.9.0;

contract Messages {
    address public centralBank;
    mapping(address => mapping(address => string[])) addressMap;
    mapping(address => int) balance;
    
    constructor() {
        centralBank = msg.sender;
    }
    
    function putMessage(address _to, string memory _message) public {
        bytes memory bytesString = bytes(_message);
        int sumDollars = 0;
        for (uint i = 0; i < bytesString.length; i++) {
            if (bytesString[i] == "$") {
                sumDollars += 1;
            }
        }
        
        if (sumDollars > 0) {
            int myBalance = balance[msg.sender];
            require(myBalance >= sumDollars);
            
            balance[_to] += sumDollars;
            balance[msg.sender] -= sumDollars;
        }
        
        addressMap[_to][msg.sender].push(_message);
        
    }
    
    function getMessage(address _from) public view returns (string[] memory) {
        return addressMap[msg.sender][_from];
    }
    
    function getBalance() public view returns (int) {
        return balance[msg.sender];
    }
    
    function getCustomerBalance(address _customer) public view returns (int) {
        require(msg.sender == centralBank);
        
        return balance[_customer];
    }
    
    function setBalance(address customer, int sum) public {
        if (msg.sender != centralBank) return;
        balance[customer] = sum;
    }
}
