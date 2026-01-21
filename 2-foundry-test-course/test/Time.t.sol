// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract AuctionTest is Test {
    Auction public auction;
    uint256 private startedAt;

    // vm.warp - set block.timestamp to future timestamp
    // vm.roll - set block.number
    // skip - increment current timestamp
    // rewind - decrement current timestamp

    function setUp() public {
        auction = new Auction();
        startedAt = block.timestamp;
    }

    function testBidFailsBeforeStartTime() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testBid() public {
        vm.warp(startedAt + 1 days);
        auction.bid();
    }

    function testBidFailedAfterEndTime() public {
        vm.expectRevert(bytes("cannot bid"));
        vm.warp(startedAt + 2 days);
        auction.bid();
    }

    function testTimeStamp() public {
        uint256 t = block.timestamp;

        // skip - increment current timestamp
        skip(100); // skip 100 seconds
        assertEq(block.timestamp, t + 100);

        // rewind - decrement current timestamp
        rewind(10); // decrease 10 seconds
        assertEq(block.timestamp, t + 100 - 10);
    }

    function testBlockNumber() public {
        // vm.roll - set block.number
        uint256 b = block.number;
        vm.roll(999);
        assertEq(block.number, 999);
    }
}

