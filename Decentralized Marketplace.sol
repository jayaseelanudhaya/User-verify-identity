//"SPDX-License-Identifier"
pragma solidity ^0.8.19;

contract Marketplace {
    
    struct Item {
        string name;
        uint price;
        address owner;
        bool isAvailable;
        address buyer;
        bool isAccepted;
    }
    
    mapping(uint => Item) public items;
    uint public itemCounter;
    
    event ItemAvailable(uint indexed itemId, string name, uint price, address indexed owner);
    event OfferPlaced(uint indexed itemId, uint price, address indexed buyer);
    event ItemAccepted(uint indexed itemId, address indexed owner, address indexed buyer);
    
    function makeItemAvailable(string memory _name, uint _price) public {
        require(_price > 0, "Price must be greater than 0");
        itemCounter++;
        items[itemCounter] = Item(_name, _price, msg.sender, true, address(0), false);
        emit ItemAvailable(itemCounter, _name, _price, msg.sender);
    }
    
    function makeOffer(uint _itemId) public payable {
        require(items[_itemId].isAvailable, "Item is not available");
        require(items[_itemId].owner != msg.sender, "Cannot buy your own item");
        require(msg.value == items[_itemId].price, "Incorrect payment amount");
        items[_itemId].buyer = msg.sender;
        items[_itemId].isAccepted = true;
        emit OfferPlaced(_itemId, msg.value, msg.sender);
    }
    
    function acceptOffer(uint _itemId) public {
        require(items[_itemId].isAvailable, "Item is not available");
        require(items[_itemId].owner == msg.sender, "Only owner can accept an offer");
        require(items[_itemId].isAccepted, "No offer has been made");
        payable(items[_itemId].owner).transfer(items[_itemId].price);
        items[_itemId].isAvailable = false;
        emit ItemAccepted(_itemId, items[_itemId].owner, items[_itemId].buyer);
    }
}

