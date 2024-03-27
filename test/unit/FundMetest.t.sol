//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
contract FundMetest is Test{
    FundMe fundme;
    DeployFundMe deployfundme;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    address USER = makeAddr("User");//This creates a fake address associated with the name User and returns it at compile time;
    function setUp()external{
        //fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(USER,STARTING_BALANCE);//Funds the fake address account with some ether
    }
    modifier Funded(){
        vm.prank(USER);
        fundme.fund{value:SEND_VALUE}();
        _;
    }
    function testMINIMUM_USDisFifty()public{
        console.log(fundme.MINIMUM_USD());
        console.log(50e18);
        assertEq(fundme.MINIMUM_USD(),50e18);
    }
    function testSenderisOwner()public{ //Us->FundMeTest->FundMe
        assertEq(fundme.i_owner(),msg.sender);

    }
    function testPriceFeedversionisAccurate()public{//Test fails because the pricefeed contract address exists only on sepolia testnet while this test is run on a blank anvil chain
        uint256 version = fundme.getversion();
        assertEq(version,4);
    }
    function testFundfailswithoutenoughETH()public{
        vm.expectRevert();//Hey, the next line should Revert
        //assertEq(This tx fails/revert)
        fundme.fund();//Interacting with function and sending 0 value
    }
    function testFundupdatesfundedDatastructures()public{
        vm.prank(USER);//The next transaction will be sent by USER
        fundme.fund{value:SEND_VALUE}();
        assertEq(fundme.dataset(USER),SEND_VALUE);
        //Now this is failing because our USER does'nt have that many funds in his account address
    }
    function testAddfundertoArrayofFunders()public Funded{
        address funder= fundme.funders(0);
        assertEq(funder,USER);
    }
    function testOnlyOwnercanWithdrawFunds()public Funded{
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }
    function testWithdrawwithaSingleFunder()public Funded{
        //Arrange
        uint256 startingownerbalance = fundme.i_owner().balance;
        uint256 startingfundmebalance = address(fundme).balance;
        //Act
        vm.prank(fundme.i_owner());
        fundme.withdraw();
        //Assert 
        uint256 endingownerbalance = fundme.i_owner().balance;
        uint256 endingfundmebalance = address(fundme).balance;
        assertEq(endingfundmebalance,0);
        assertEq(startingownerbalance+startingfundmebalance,endingownerbalance);
    }
    function testWithdrawwithMultipleFunders()public{
        //Arrange
        uint160 totalfunders = 10;
        uint160 funderindex = 1;
        for(uint160 i= funderindex;i<totalfunders;i++)
        {
            hoax(address(i),SEND_VALUE);//Creates fake addresses associated with a random no. and funds them
            //The next transaction is carried out by the address created
            fundme.fund{value:SEND_VALUE}();
        }
        uint256 startingownerbalance = fundme.i_owner().balance;
        uint256 startingfundmebalance = address(fundme).balance;
        //Act
        vm.prank(fundme.i_owner());
        fundme.withdraw();
        //Assert
        assert(address(fundme).balance==0);
        assertEq(startingfundmebalance+startingownerbalance,fundme.i_owner().balance);
    }
}