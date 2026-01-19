// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {FirstApp} from "../src/FirstApp.sol";

contract FirstAppTest is Test {
    FirstApp firstApp;

    function setUp() public {
        firstApp = new FirstApp();
    }

    function testInc() public {
        firstApp.inc();
        firstApp.inc();
        firstApp.inc();
        assertEq(firstApp.count(), 3);
    }

    /**
     * In the test, we incremented `count` value 3 times then we decreased it by 1 time
     * the final `count` value will be 2
     */
    function testDec() public {
        // Increment the count value
        firstApp.inc();
        firstApp.inc();
        firstApp.inc();

        // Decrement the count value
        firstApp.dec();

        // Assert
        assertEq(firstApp.count(), 2);
    }

    /**
     * Here we check, `get()` function returns `count` value
     * first we increase `count` value to 1
     * then call the `get()` function which returns the latest value of count
     * we can check without increment the `count` value, but for zero value in assert instead of 1
     */
    function testGetCountValue() public {
        firstApp.inc();

        assertEq(firstApp.get(), 1);
    }

    /////////////////////////////////////
    /// IMPORTANT NOTES ON GAS REPORT ///
    /////////////////////////////////////

    /**
     * For checking gas report of a test or all the tests, we need to write `--gas-report` with test like this
     * 
     *    forge test --mt testInc --gas-report
     * 
     * It will return the gas report of that test in the terminal
     * 
     * 
╭------------------------------------+-----------------+-------+--------+-------+---------╮
| src/FirstApp.sol:FirstApp Contract |                 |       |        |       |         |
+=========================================================================================+
| Deployment Cost                    | Deployment Size |       |        |       |         |
|------------------------------------+-----------------+-------+--------+-------+---------|
| 155067                             | 501             |       |        |       |         |
|------------------------------------+-----------------+-------+--------+-------+---------|
|                                    |                 |       |        |       |         |
|------------------------------------+-----------------+-------+--------+-------+---------|
| Function Name                      | Min             | Avg   | Median | Max   | # Calls |
|------------------------------------+-----------------+-------+--------+-------+---------|
| count                              | 2402            | 2402  | 2402   | 2402  | 1       |
|------------------------------------+-----------------+-------+--------+-------+---------|
| inc                                | 26417           | 32117 | 26417  | 43517 | 3       |
╰------------------------------------+-----------------+-------+--------+-------+---------╯

     */
}
