//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script{
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostrecentlydeployed)public{
       
        FundMe(payable(mostrecentlydeployed)).fund{value:SEND_VALUE}();
       
        console.log("Funded FundMe with %s",SEND_VALUE);
    }
    function run()external{
        address mostrecentlydeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        fundFundMe(mostrecentlydeployed);
        vm.stopBroadcast();
    }

}
contract WithdrawFundMe is Script{
    function withdrawFundMe(address mostrecentlydeployed)public{
        vm.startBroadcast();
        FundMe(mostrecentlydeployed).withdraw();  
        vm.stopBroadcast();   
    }
    function run()external{
        address mostrecentlydeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        withdrawFundMe(mostrecentlydeployed);
        
        
    }
}