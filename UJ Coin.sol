pragma solidity ^0.4.9;

contract UJCoin {
    string public name = "UJ Coin";
    string public symbol = "UJC";
    uint256 public totalSupply = 100;
    uint8 public decimals = 18;

    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor()public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}
