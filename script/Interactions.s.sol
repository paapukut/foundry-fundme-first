//here we need to make two contract
//one for fund
//one for withdraw
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from 'forge-std/Script.sol';
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
/*
this is an old example of intraction with a deployed contract
first we have to deploy the contract
with that contract we are interacting 
insted of that here they are taking the last contract address with the devopstools
bu adding ffi=true in the .toml file we can directly interact with the terminal or the machine
to take the address
by ffi = true in .toml we get th epermission to take the last contract addrss
*/




contract FundFundMe is Script{
    
    function fundFundMe(address _lastAddress) public{
        uint SEND_VALUE = 1e18;
        //FundMe fundMe = FundMe(payable(_lastAddress));
        vm.startBroadcast();
        //can be also written as FundMe(payable _lastAddress).fund{value:SEND_VALUE}();
        FundMe(payable(_lastAddress)).fund{value:SEND_VALUE}; 
        vm.stopBroadcast();
    }
    function run() external {
        address fundMeAddress = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        //this is collecting from the broadcast/chainid/recent deployed contracts
    
    fundFundMe(fundMeAddress);
    }
}
    contract WithdrawFundMe is Script{
    
    function withdrawFundMe(address _lastAddress) public{
        //FundMe fundMe = FundMe(payable(_lastAddress));
        vm.startBroadcast();
        //can be also written as FundMe(payable _lastAddress).withDraw();
        FundMe(payable(_lastAddress)).withdraw(); 
        vm.stopBroadcast();
    }
    function run() external {
        address fundMeAddress = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        //this is collecting from the broadcast/chainid/recent deployed contracts
    
    withdrawFundMe(fundMeAddress);
    }



}