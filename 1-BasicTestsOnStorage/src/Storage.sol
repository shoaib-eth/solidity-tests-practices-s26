// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Storage {
    uint256 storedData;

    function set(uint256 x) public {
        storedData = x;
    }

    function get() public view returns (uint256) {
        return storedData;
    }
}
