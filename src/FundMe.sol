//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor}from "./PriceConvertor.sol";
error Not_Owner();
contract FundMe {
    using PriceConvertor for uint256;
    address[] public funders;
    mapping(address=>uint256) public dataset;
    uint256 constant public MINIMUM_USD = 50e18;
    address public immutable i_owner;
    AggregatorV3Interface private s_pricefeed;

    constructor(address pricefeed){
        i_owner= msg.sender;
        s_pricefeed = AggregatorV3Interface(pricefeed);
    }
    function fund()payable public{
        require(msg.value.getConversionRate(s_pricefeed)>MINIMUM_USD,"Did'nt send enough ETH");
        funders.push(msg.sender);
        dataset[msg.sender]= dataset[msg.sender] + msg.value;
    }
    modifier OnlyOwner(){
        if(msg.sender!=i_owner){
            revert Not_Owner();
        }
        _;
    }
    function withdraw()public OnlyOwner{
        for(uint256 i=0;i<funders.length;i++)
        {
           address funder=funders[i];
           dataset[funder]=0;
        }
        funders=new address[](0);
        payable(msg.sender).transfer(address(this).balance);
        
    }
    function getversion()public view returns(uint256){

        return s_pricefeed.version();
      }
}