//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,WithdrawFundMe} from "script/Interactions.s.sol";

contract InteractionsTest is Test{
    FundMe fundme;
    DeployFundMe deployfundme;
    FundFundMe fundFundMe;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    address USER = makeAddr("User");

    function setUp()external{
        deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(USER,STARTING_BALANCE);
    }
    function testUsercanFund()public{
        fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe),STARTING_BALANCE);  
        fundFundMe.fundFundMe(address(fundme));
        assertEq(fundme.funders(0),address(fundFundMe));
    }
}
