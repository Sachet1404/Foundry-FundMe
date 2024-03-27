//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
 contract DeployFundMe is Script{
    FundMe fundme;
    HelperConfig helperconfig;
    function run()external returns(FundMe){
        helperconfig =new HelperConfig();
        (address ethUsdpricefeed)= helperconfig.ActiveNetworkConfig();
        vm.startBroadcast();
        fundme = new FundMe(ethUsdpricefeed);
        vm.stopBroadcast();
        return fundme;
    }
 }