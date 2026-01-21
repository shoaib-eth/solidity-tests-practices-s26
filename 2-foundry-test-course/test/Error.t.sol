// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract ErrorTest is Test {
    Error err;

    function setUp() public {
        err = new Error();
    }

    function testThroughError() public {
        vm.expectRevert();
        err.throughError();
    }

    function testThroughErrorRequireMessage() public {
        vm.expectRevert(bytes("Not Authorized"));
        err.throughError();
    }

    function testCustomError() public {
        vm.expectRevert(Error.Error_NotAuthorized.selector);
        err.throughCustomError();
    }
}
