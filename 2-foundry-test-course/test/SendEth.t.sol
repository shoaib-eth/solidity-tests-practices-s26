// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {SendEth} from "../src/SendEth.sol";

// Examples of deal and hoax
// deal(address, uint) - Set balance of address
// hoax(address, uint) - deal + prank, Sets up a prank and set balance

contract SendEthTest is Test {
    SendEth send;

    function setUp() public {
        send = new SendEth();
    }

    // recieve eth from wallet
    receive() external payable {}

    function _send(uint256 amount) private {
        (bool success,) = address(send).call{value: amount}("");
        require(success, "Transfer Failed!");
    }

    function testEthBalance() public {
        console.log("ETH Balance: ", address(this).balance / 1e18);
    }

    /**
     * Use of `vm.deal()`
     */
    function testSendEth() public {
        // deal(address, uint) - Set balance of address
        vm.deal(address(1), 100);
        assertEq(address(1).balance, 100);
    }

    /**
     * Use of `hoax`
     * It handles `vm.deal` + `vm.prank` at once
     * see the output by -vvvv for more understanding
     */
    function testSendEthWithAddress() public {
        // hoax(address, uint) - deal + prank, Sets up a prank and set balance
        hoax(address(1), 456);
        _send(456);
    }

    function testWalletBalance() public {
        uint256 balanceBefore = address(send).balance;
        console.log("Balance Before: ", balanceBefore);

        hoax(address(1), 100);
        _send(100);

        uint256 balanceAfter = address(send).balance;
        console.log("Balance After: ", balanceBefore + balanceAfter);
    }
}
