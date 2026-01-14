// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test} from "forge-std/Test.sol";
import {Coin} from "../src/Subcurrency.sol";

contract SubcurrencyTest is Test {
    Coin coin;

    address deployer;
    address alice;
    address bob;

    function setUp() external {
        deployer = makeAddr("deployer");
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        vm.prank(deployer);
        coin = new Coin();
    }

    function testMinterIsDeployer() public {
        assertEq(coin.minter(), deployer);
    }

    function testInitialBalanceIsZero() public {
        assertEq(coin.balances(alice), 0);
        assertEq(coin.balances(bob), 0);
    }

    function testMinterCanMint() public {
        vm.prank(deployer);
        coin.mint(alice, 100);

        assertEq(coin.balances(alice), 100);
    }

    function testNonMinterCannotMint() public {
        vm.prank(alice);

        vm.expectRevert();
        coin.mint(bob, 100);
    }

    function testMintAccumulatesBalance() public {
        vm.startPrank(deployer);
        coin.mint(alice, 100);
        coin.mint(alice, 50);
        vm.stopPrank();

        assertEq(coin.balances(alice), 150);
    }

    function testSendTransfersBalanceCorrectly() public {
        vm.prank(deployer);
        coin.mint(alice, 100);

        vm.prank(alice);
        coin.send(bob, 50);

        assertEq(coin.balances(alice), 50);
        assertEq(coin.balances(bob), 50);
    }

    function testSendRevertsIfInsufficientBalance() public {
        vm.prank(deployer);
        coin.mint(alice, 30);

        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Coin.InsufficientBalance.selector, 50, 30));

        coin.send(bob, 50);
    }

    function testSendEmitsEvent() public {
        vm.prank(deployer);
        coin.mint(alice, 100);

        vm.expectEmit(true, true, true, true);
        emit Coin.Sent(alice, bob, 50);

        vm.prank(alice);
        coin.send(bob, 50);
    }

    /**
     * FUZZ TEST
     */

    function testFuzzSend(uint256 mintAmount, uint256 sendAmount) public {
        mintAmount = bound(mintAmount, 0, 1e18);
        sendAmount = bound(sendAmount, 0, mintAmount);

        vm.prank(deployer);
        coin.mint(alice, mintAmount);

        vm.prank(alice);
        coin.send(bob, sendAmount);

        assertEq(coin.balances(bob), sendAmount);
        assertEq(coin.balances(alice), mintAmount - sendAmount);
    }
}
