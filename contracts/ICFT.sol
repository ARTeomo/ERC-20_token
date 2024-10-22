// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract IndependentCapitalFundToken is ERC20, Ownable {
    // Addresses for token distribution
    address public investors;
    address public projectTeam;
    address public reserve;
    address public marketing;
    address public communityIncentives;

    // Mapping to track lock-up periods
    mapping(address => uint256) public lockupExpiry;

    constructor(
        address initialOwner,
        address _investors,
        address _projectTeam,
        address _reserve,
        address _marketing,
        address _communityIncentives,
        uint256 initialSupply
    ) ERC20("Independent Capital Fund Token", "ICFT") Ownable(initialOwner) {
        require(initialOwner != address(0), "Invalid owner address");

        // Assign addresses for distribution
        investors = _investors;
        projectTeam = _projectTeam;
        reserve = _reserve;
        marketing = _marketing;
        communityIncentives = _communityIncentives;

        // Calculate and distribute the initial supply
        uint256 investorsAmount = (initialSupply * 60) / 100;
        uint256 projectTeamAmount = (initialSupply * 20) / 100;
        uint256 reserveAmount = (initialSupply * 10) / 100;
        uint256 marketingAmount = (initialSupply * 5) / 100;
        uint256 communityIncentivesAmount = (initialSupply * 5) / 100;

        // Mint tokens to each address
        _mint(_investors, investorsAmount);
        _mint(_projectTeam, projectTeamAmount);
        _mint(_reserve, reserveAmount);
        _mint(_marketing, marketingAmount);
        _mint(_communityIncentives, communityIncentivesAmount);

        // Set lock-up period for the project team
        lockupExpiry[_projectTeam] = block.timestamp + 365 days;
    }

    // Override the transfer function to enforce lock-up period
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(block.timestamp >= lockupExpiry[msg.sender], "Tokens are locked");
        return super.transfer(to, amount);
    }

    // Override the transferFrom function to enforce lock-up period
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(block.timestamp >= lockupExpiry[from], "Tokens are locked");
        return super.transferFrom(from, to, amount);
    }

    // Function to mint new tokens, only accessible by the owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to burn tokens from the owner's balance, only accessible by the owner
    function burn(uint256 amount) public onlyOwner {
        _burn(msg.sender, amount);
    }

    // Placeholder function for upgrading the contract, only accessible by the owner
    function upgradeContract() public onlyOwner {
        // Logic for upgrading the contract goes here
    }
}
