// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

contract EventTest is Test {
    Event e;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        e = new Event();
    }

    function testEmitTransferEvent() public {
        // function expectEmit(
        //     bool checkTopic1,
        //     bool checkTopic2,
        //     bool checkTopic3,
        //     bool checkData
        // ) external;

        // 1. Tell Foundry which data to check
        // Check index 1, index 2 and data
        vm.expectEmit(true, true, false, true);

        // 2. Emit the expected event
        emit Transfer(address(this), address(123), 456);

        // 3. Call the function that shuld emit the event
        e.transfer(address(this), address(123), 456);
    }

    /**
     * it only check for index-1 of event,
     * no matter, if we changed index-2, index-3 values
     * it always checks for index-1 of event
     * to check for only index-1, we have to make true only index-1 rest will be false
     */
    function testCheckForIndexOneOnly() public {
        vm.expectEmit(true, false, false, false);
        emit Transfer(address(this), address(123), 456);
        e.transfer(address(this), address(123), 456);
    }

    function testManyEmitTransferEvent() public {
        address[] memory to = new address[](2);
        to[0] = address(123);
        to[1] = address(234);

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 783;
        amounts[1] = 675;

        for (uint256 i = 0; i < to.length; i++) {
            // 1. Tell Foundry which data to check
            vm.expectEmit(true, false, false, false);

            // 2. Emit the expected event
            emit Transfer(address(this), to[i], amounts[1]);
        }

        // 3. Call the function that shuld emit the event
        e.transferMany(address(this), to, amounts);
    }
}
