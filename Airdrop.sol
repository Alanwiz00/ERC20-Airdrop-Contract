// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Assume you have an ERC20 token contract with the following interface
interface ERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract AirdropContract {
    address public tokenAddress;  // Address of the ERC20 token
    uint256 public airdropAmount; // Amount of tokens to distribute per address
    address public owner;         // Address of the contract deployer

    constructor(address _tokenAddress, uint256 _airdropAmount) {
        tokenAddress = _tokenAddress;
        airdropAmount = _airdropAmount;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function setAirdropAmount(uint256 _airdropAmount) public onlyOwner {
        airdropAmount = _airdropAmount;
    }

    function airdrop(address[] memory recipients) public onlyOwner {
        ERC20 token = ERC20(tokenAddress);
        require(token.balanceOf(address(this)) >= airdropAmount * recipients.length, "Insufficient contract balance for airdrop");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Invalid recipient address");
            token.transfer(recipients[i], airdropAmount);
        }
    }

    function withdraw() public onlyOwner {
        ERC20 token = ERC20(tokenAddress);
        uint256 contractBalance = token.balanceOf(address(this));
        require(contractBalance > 0, "No balance to withdraw");
        
        token.transfer(owner, contractBalance);
    }
}
