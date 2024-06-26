// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenICO is Ownable {
    MyToken public token;
    uint256 public rate;
    uint256 public endICO;
    uint256 public tokensSold;

    event TokensPurchased(address indexed buyer, uint256 amount);

    constructor(MyToken _token, uint256 _rate, uint256 duration) Ownable(msg.sender) {
        token = _token;
        rate = _rate;
        endICO = block.timestamp + duration;
    }

    modifier icoActive() {
        require(block.timestamp < endICO, "ICO has ended");
        _;
    }

    function buyTokens() public payable icoActive {
        uint256 tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in the reserve");

        token.transfer(msg.sender, tokenAmount);
        tokensSold += tokenAmount;

        emit TokensPurchased(msg.sender, tokenAmount);
    }

    function endSale() public onlyOwner {
        require(block.timestamp >= endICO, "ICO is still active");

        uint256 remainingTokens = token.balanceOf(address(this));
        if (remainingTokens > 0) {
            token.transfer(owner(), remainingTokens);
        }

        selfdestruct(payable(owner()));
    }
}
