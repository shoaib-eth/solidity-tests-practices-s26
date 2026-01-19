// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract FirstToken is ERC20("FirstToken", "FT", 18) {}
