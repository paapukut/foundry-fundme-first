//SPDX-Liccense-Identifier: MIT
pragma solidity ^0.8.19;

import {MockV3Aggregator} from "../test/Mock/MockV3Aggregator.sol";
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaAdress();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetAddress();
        } else {
            activeNetworkConfig = getMockAddress();
        }
    }

    struct networkConfig {
        address priceFeed;
    }

    networkConfig public activeNetworkConfig;

    function getSepoliaAdress() public pure returns (networkConfig memory) {
        //why memory
        networkConfig memory sepoliaAddress = networkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return sepoliaAddress;
    }

    function getMainnetAddress() public pure returns (networkConfig memory) {
        //why pure
        networkConfig memory mainnetAddress = networkConfig(0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8);
        return mainnetAddress;
    }

    function getMockAddress() public returns (networkConfig memory) {
        //why here no pure

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        MockV3Aggregator mock = new MockV3Aggregator(3, 1e18);
        vm.startBroadcast();
        networkConfig memory mockAddress = networkConfig(address(mock));
        vm.stopBroadcast();
        return mockAddress;
    }
}
