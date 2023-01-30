// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
 
uint constant MIN_GAP = 1 seconds;
uint constant MAX_GAP = 5 minutes;
uint constant START_GAP = 5 minutes;
 
/** 
 * @title Biggest-WETH-Dick
 * @dev Implements BWD game
 */
contract BiggestWethDick is Ownable {
    struct CurrentBid {
        address bidder;
        uint timestamp;
    }
 
    bool public isOver;
    uint public totalValue;
    uint public timeGap = START_GAP;
    address tokenAddress;
    CurrentBid public currentBid;
 
    event NewBid(address bidder, uint value);
    event GameOver(address winner);
 
    constructor(address tokenAddress_) {
        currentBid.timestamp = block.timestamp;
        tokenAddress = tokenAddress_;
    }
 
    modifier gameNotOver{
        require(
            !checkIfOver(),
            "Game is over"
        );
        _;
    }
 
    function bid(uint amount) public gameNotOver {
        require(
            amount > totalValue,
            "Your bet should be higher than currect bid."
        );
 
        totalValue += amount;

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
 
        currentBid.bidder = msg.sender;
        currentBid.timestamp = block.timestamp;
 
        emit NewBid(currentBid.bidder, totalValue);
    }
 
 
    function changeGap(uint newGap) public onlyOwner() {
        require(
            newGap <= MAX_GAP && newGap >= MIN_GAP,
            "Gap should be in a set range"
        );
 
        timeGap = newGap;
    }
 
    function finish() public {
        require(
            checkIfOver(),
            "Game is not over"
        );
 
        if(!isOver) {
            emit GameOver(currentBid.bidder);
        }
 
        isOver = true;
 
        uint ownerFee = totalValue / 100;
 
        IERC20(tokenAddress).transfer(owner(), ownerFee);
        IERC20(tokenAddress).transfer(currentBid.bidder, totalValue - ownerFee);
    }
 
    function checkIfOver() public view returns (bool) {
        return isOver || timeLeft() == 0;
    }
 
    function timeLeft() public view returns (uint) {
        if (currentBid.timestamp + timeGap > block.timestamp) {
            return currentBid.timestamp + timeGap - block.timestamp;
        }
        else {
            return 0;
        }
    }
}