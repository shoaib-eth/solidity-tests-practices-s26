// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";

interface IWETH {
    function balanceOf(address) external view returns (uint256);
    function deposit() external payable;
}

contract ForkTest is Test {
    IWETH public weth;

    function setUp() public {
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testDepositByFork() public {
        uint256 balBefore = weth.balanceOf(address(this));
        console.log("balance before", balBefore);

        weth.deposit{value: 100}();

        uint256 balAfter = weth.balanceOf(address(this));
        console.log("balance after", balAfter);
    }
}