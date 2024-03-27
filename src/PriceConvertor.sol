//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConvertor{
    function getprice(AggregatorV3Interface pricefeed)internal view returns(uint256){
        //ABI
        //Address

        (,int256 price,,,)=pricefeed.latestRoundData();
        return uint256(price*10000000000);
    }
    function getConversionRate(uint256 ethAmount,AggregatorV3Interface pricefeed)internal view returns(uint256){
        uint256 ethPrice= getprice(pricefeed);
        uint256 ethAmountinUSD= (ethPrice * ethAmount)/1000000000000000000;
        return ethAmountinUSD;
    }
    }
    
