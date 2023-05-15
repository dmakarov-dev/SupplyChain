// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address owner;
        bool isSold;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;

    event ProductCreated(uint256 indexed id, string name, uint256 price, address owner);
    event ProductSold(uint256 indexed id, address buyer);

    constructor() {
        productCount = 0;
    }

    function createProduct(string memory _name, uint256 _price) public {
        require(bytes(_name).length > 0, "Product name must not be empty");
        require(_price > 0, "Product price must be greater than 0");

        productCount++;

        Product storage newProduct = products[productCount];
        newProduct.id = productCount;
        newProduct.name = _name;
        newProduct.price = _price;
        newProduct.owner = msg.sender;
        newProduct.isSold = false;

        emit ProductCreated(productCount, _name, _price, msg.sender);
    }

    function buyProduct(uint256 _id) public payable {
        require(_id > 0 && _id <= productCount, "Invalid product ID");

        Product storage product = products[_id];
        require(!product.isSold, "Product is already sold");
        require(msg.value >= product.price, "Insufficient payment");

        product.isSold = true;
        product.owner.transfer(product.price);

        emit ProductSold(_id, msg.sender);
    }
}
