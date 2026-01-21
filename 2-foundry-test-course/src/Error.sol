// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Error {
    error Error_NotAuthorized();

    function throughError() external {
        require(false, "Not Authorized");
    }

    function throughCustomError() external {
        revert Error_NotAuthorized();
    }
}
