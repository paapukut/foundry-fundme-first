// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library priceConverter {
    function getPrice(AggregatorV3Interface _priceFeed) public view returns (uint256) {
        (, int256 price,,,) = _priceFeed.latestRoundData();
        return uint256(price);
    }

    function getConversionRate(uint256 _ethAmount, AggregatorV3Interface _priceFeed) public view returns (uint256) {
        uint256 eth = _ethAmount;
        uint256 usd = getPrice(_priceFeed);
        uint256 converted = (eth * (usd * 1e10)) / 1e18;
        return converted;
    }
}
