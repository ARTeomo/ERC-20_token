# Independent Capital Fund Token (ICFT)

## Introduction
The **Independent Capital Fund Token (ICFT)** is an ERC-20 compliant token built on the Ethereum blockchain. This smart contract is designed to manage the distribution, minting, burning, and transfer of ICFT tokens with specific allocation and lock-up periods to ensure proper governance and financial stability.

## Contract Details

### SPDX License
This contract is released under the [MIT License](https://opensource.org/licenses/MIT).

### Pragma Solidity
The contract is written in Solidity version `^0.8.0`.

### Imports
The contract utilizes OpenZeppelin’s ERC20 and Ownable implementations for robust token standards and ownership management:
```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```

## Contract Overview

### State Variables
- **investors**: Address for the investors' allocation.
- **projectTeam**: Address for the project team and consultants' allocation.
- **reserve**: Address for the reserve allocation.
- **marketing**: Address for marketing and partnerships allocation.
- **communityIncentives**: Address for community incentives allocation.
- **lockupExpiry**: Mapping to track lock-up periods for addresses.

### Constructor
The constructor initializes the contract with the initial owner, distribution addresses, and initial supply. The token distribution is as follows:
- 60% to investors
- 20% to the project team
- 10% to reserves
- 5% for marketing
- 5% for community incentives

```solidity
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
```

## Functions

### Transfer
Overrides the `transfer` function to enforce the lock-up period.
```solidity
function transfer(address to, uint256 amount) public override returns (bool) {
    require(block.timestamp >= lockupExpiry[msg.sender], "Tokens are locked");
    return super.transfer(to, amount);
}
```

### TransferFrom
Overrides the `transferFrom` function to enforce the lock-up period.
```solidity
function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
    require(block.timestamp >= lockupExpiry[from], "Tokens are locked");
    return super.transferFrom(from, to, amount);
}
```

### Mint
Function to mint new tokens, accessible only by the owner.
```solidity
function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}
```

### Burn
Function to burn tokens from the owner's balance, accessible only by the owner.
```solidity
function burn(uint256 amount) public onlyOwner {
    _burn(msg.sender, amount);
}
```

### UpgradeContract
Placeholder function for upgrading the contract, accessible only by the owner.
```solidity
function upgradeContract() public onlyOwner {
    // Logic for upgrading the contract goes here
}
```

## Usage
Deploy the contract by providing the initial owner, addresses for distribution, and the initial token supply.

### Example Deployment
```solidity
IndependentCapitalFundToken(
    initialOwner, 
    investorsAddress, 
    projectTeamAddress, 
    reserveAddress, 
    marketingAddress, 
    communityIncentivesAddress, 
    1000000 * 10**18  // 1 million tokens
);
```

## License
This contract is licensed under the [MIT License](https://opensource.org/licenses/MIT).
