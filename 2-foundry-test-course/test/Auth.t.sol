// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract Auth is Test {
    Wallet wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function testSetOwner() public {
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    function testRevertNotOwner() public {
        vm.prank(address(1));
        vm.expectRevert();
        wallet.setOwner(address(1));
    }

    /**
     * Here first `setOwner()` called by `address(this),
     * then we `setOwner()` three more times with `address(1) which is the owner,
     * after `vm.stopPrank()` we try to `setOwner` but this time the caller is `address(this)`, which should be failed
     * See test output for more understanding
     */
    function testRevertSetOwnerAgain() public {
        // msg.sender == address(this)
        wallet.setOwner(address(1));

        // msg.sender == address(1)
        vm.startPrank(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        vm.stopPrank();

        // msg.sender() == address(this)
        vm.expectRevert();
        wallet.setOwner(address(1));
    }
}
