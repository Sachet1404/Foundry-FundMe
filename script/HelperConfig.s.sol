//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
//Deploy mocks when we are on a local anvil chain
//Keep track of contract address across different chains

contract HelperConfig is Script{
    struct NetworkConfig {
        address pricefeed;
    }
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    NetworkConfig public ActiveNetworkConfig;
    constructor(){
        if(block.chainid==11155111)
        {
            ActiveNetworkConfig= getsepoliaEthconfig();
        }
        else if(block.chainid==1)
        {
            ActiveNetworkConfig= getmainEthconfig();
        }
        else if(block.chainid==31337)
        {
            ActiveNetworkConfig= getanvilEthconfig();
        }

    }
    function getsepoliaEthconfig()public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return sepoliaConfig;
    }
    function getmainEthconfig()public pure returns(NetworkConfig memory){
        NetworkConfig memory ethmainnetConfig = NetworkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        return ethmainnetConfig;
    }
    function getanvilEthconfig()public  returns(NetworkConfig memory){
        if(ActiveNetworkConfig.pricefeed!=address(0))
        {
            return ActiveNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockpricefeed = new MockV3Aggregator(DECIMAL,INITIAL_PRICE);
        vm.stopBroadcast();
        return NetworkConfig(address(mockpricefeed));
    }

}
