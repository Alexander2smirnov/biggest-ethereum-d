// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 
/** 
 * @title WETH contract 
 */
contract WETH is ERC20 {
    constructor() ERC20("Wrapped ETH", "WETH") {}

    function wrap() public payable {
        _mint(msg.sender, msg.value);
    }
    
    function unwrap(uint amount) public {
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
    }
}