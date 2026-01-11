// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test} from "forge-std/Test.sol";
import {Storage} from "../src/Storage.sol";

contract StorageTest is Test {
    Storage storageContract;

    function setUp() external {
        storageContract = new Storage();
    }

    /**
     * NORMAL TEST
     */
    function testNumberIsUpdate() public {
        // Act
        storageContract.set(10);

        // Assert
        uint256 number = storageContract.get();
        assertEq(number, 10);
    }

    function testDefaultValueIsZero() public {
        assertEq(storageContract.get(), 0);
    }

    /**
     * FUZZ TEST
     */
    function testNumberIsUpdateByFuzz(uint256 x) public {
        // Act
        // vm.assume(x < 1000);  // It means, in set() function `x` value will be come in below 1000
        uint256 bounded = bound(x, 1, 200); // It means in test value will be pass from 1 to 200 range only
        storageContract.set(bounded);

        // Assert
        uint256 number = storageContract.get();
        assertEq(number, bounded);
    }

    // It returns only last set value, if we try to assert with `x` will give an error
    // see the test output for more details
    function testOverwriteValue(uint256 x, uint256 y) public {
        x = bound(x, 0, 1999);
        y = bound(y, 10, 1000);

        storageContract.set(x);
        storageContract.set(y);

        assertEq(storageContract.get(), y);
    }
}

// Note 📝

// `vm.assume` and `bound` are very useful when we want to check out function for specific range of numbers.
