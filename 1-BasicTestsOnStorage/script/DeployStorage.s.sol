// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {Storage} from "../src/Storage.sol";

contract DeployeStorage is Script {
    Storage deployContract;

    function run() external returns (Storage) {
        vm.startBroadcast();
        deployContract = new Storage();
        vm.stopBroadcast();
        return deployContract;
    }
}
