//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {priceConverter} from "./PriceConverter.sol";

error notOwner();
error insufficientFund();

contract FundMe {
    using priceConverter for uint256;

    AggregatorV3Interface priceFeed;

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 1e18;
    //these all are storage and these will cost more gasprice when it is using
    address[] public funders;
    mapping(address => uint256) public balanceAmount;

    function fund() public payable {
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "insuffisient fund");
        funders.push(msg.sender);
        balanceAmount[msg.sender] = balanceAmount[msg.sender] + msg.value;
    }

    function getVersion() public view returns (uint256) {
        uint256 version = priceFeed.version();
        return version;
    }

    function getPrice() public view returns (uint256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function cheaperwithdraw() public payable onlyOwner {
        uint256 noOfFunders = funders.length;
        for (uint256 i = 0; i < noOfFunders; i++) {
            address funder = funders[i];
            balanceAmount[funder] = 0;
        }
        funders = new address[](0);

        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "transaction failed");
    }

    function withdraw() public payable onlyOwner {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            balanceAmount[funder] = 0;
        }
        funders = new address[](0);

        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "transaction failed");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert notOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function knowBalance(address _senderAddress) public view returns (uint256) {
        uint256 currentBalance = balanceAmount[_senderAddress];
        return currentBalance;
    }

    function knowFunder(uint256 _index) public view returns (address) {
        address funder = funders[_index];
        return funder;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
