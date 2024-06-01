//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    FundMe fundMe;
    HelperConfig helperConfig;

    function run() public returns (FundMe) {
        helperConfig = new HelperConfig();
        address network = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        fundMe = new FundMe(network);
        vm.stopBroadcast();

        return fundMe;
    }
}
