//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";

import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract TestFundMe is Test {
    uint256 constant SEND_ETHER = 1e18;
    uint256 STARTING_BALANCE = 10e18;
    uint256 number = 1;
    FundMe fundMe;
    //this is a way to make an address for any other use
    //now this is using for naking a prank address to make the transactions i the tests
    address USER = makeAddr("user");

    function setUp() external {
        number = 6;
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, 100e18); //this is the way to set some fake balance to the fake address
            //this is doing when the time of deployment that is why it is in setup function
            //without this if we are using the fake USER it will show out of balance
    }

    function testDemo() external view {
        assertEq(number, 6);
    }

    function testMINIMUM_USD() external view {
        uint256 minimum = fundMe.MINIMUM_USD();
        assertEq(minimum, 1e18);
    }

    function testIowner() external view {
        address owner = fundMe.i_owner();
        assertEq(owner, msg.sender);
    }

    function testgetVersion() external view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testgetPrice() external view {
        uint256 price = fundMe.getPrice();
        assertEq(price, 1e18);
    }

    function testDemo2() external {
        number = 3;
    }

    function testfundMe() external {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFund() external {
        fundMe.fund{value: 1e18}();
    }

    function testFundIsUpdated() external {
        fundMe.fund{value: 3e18}();
        uint256 fundedAmount = fundMe.knowBalance(address(this));
        assertEq(fundedAmount, 3e18);
    }

    function testFundIsUpdated2() external {
        vm.prank(USER); //this  funtion means next txn will be prank with our made adress
        //for the difficulty of finding the address this fake addtress is making
        //this is the way of making fake address to send TXN
        //makeAddr() for address making
        //vm.prank() to initialize the fake address it before TXN
        fundMe.fund{value: SEND_ETHER}();
        uint256 fundedAmount = fundMe.knowBalance(USER); //to test the vm.prank() function work
        assertEq(fundedAmount, SEND_ETHER);
    }

    function testFunderAddress() external {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETHER}();
        address funder = fundMe.knowFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_ETHER}();
        _;
    }

    function testWithdrawOnlyOwner() external funded {
        // vm.prank(USER);
        //fundMe.fund{value:SEND_ETHER}();
    }

    function testWithdraw() external funded {
        //insted of using fund function we made a modifier and applied that in this function
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithOwner() external funded {
        //arrange
        uint256 startingContractBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        //act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 endingContractBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingContractBalance, 0);
        assertEq(startingOwnerBalance + startingContractBalance, endingOwnerBalance);
    }

    function testWithdrawMultipleFunders() external {
        uint160 staringIndex = 2;
        uint160 noOfIndex = 10;
        for (uint160 i = staringIndex; i < noOfIndex; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_ETHER}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalnce = fundMe.getOwner().balance;

        /* THIS IS GAS MEASURING FOR PORTION AND TO SET GAS
        vm.txGasPrice(1);//this is to set the rest gas price
        uint gasStart = gasleft();//this is to know the gas left in the gas limit 
        // here left 1000
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint gasEnd = gasleft();//this is to find the gas spend b/t the start and end of this gasleft function
        //here spend 800
        //so spending b/t gasleft function is 1000-800 
        uint256 gasSpend = (gasStart-gasEnd)*tx.gasprice;//this tx function is to know the current gas price

       // console.log(gasSpend);
       */
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalnce == fundMe.getOwner().balance);
    }
    function testcheaperWithdrawMultipleFunders() external {
        uint160 staringIndex = 2;
        uint160 noOfIndex = 10;
        for (uint160 i = staringIndex; i < noOfIndex; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_ETHER}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalnce = fundMe.getOwner().balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperwithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalnce == fundMe.getOwner().balance);
    }

}
