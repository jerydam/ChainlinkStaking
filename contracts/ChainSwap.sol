// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "./IUSD.sol";

contract swapper {

    address owner;
    uint256 decimal = 1e18;
    IERC20 public token1;
    IERC20 public token2;
    AggregatorV3Interface private pricefeeddai;
    //  AggregatorV3Interface private pricefeedusd;
    AggregatorV3Interface private pricefeedeth;
    AggregatorV3Interface private pricefeedbat;
    address public ethereum;

    //token1 == Dai
    //token2 == bat

     
    constructor() {
        owner = msg.sender;
        pricefeeddai = AggregatorV3Interface(0x773616E4d11A78F511299002da57A0a94577F1f4);
        pricefeedeth = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        pricefeedbat = AggregatorV3Interface(0x0d16d4528239e9ee52fa531af613AcdB23D88c94);
        token1 = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        token2 = IERC20(0x0D8775F648430679A709E98d2b0Cb6250d2887EF);
        

    }



    function getLatestPrice (AggregatorV3Interface pricefeed) public view returns (uint80 roundID, int price,
        uint  startedAt,uint timeStamp,uint80 answeredInRound) {
        (roundID, price,startedAt,timeStamp,answeredInRound) = pricefeed.latestRoundData();
    } 


    function swapBatToDai(uint256 _amounttoswap) public returns(bool swapped){
        (, int daiPrice, , , ) = getLatestPrice(pricefeeddai);
        (, int batPrice, , , ) = getLatestPrice(pricefeedbat);
        uint256 batPriceInUsd = uint256(batPrice);
        uint256 daiPriceInUsd = uint256(daiPrice);
        uint256 daiPriceInbat = batPriceInUsd * decimal / daiPriceInUsd;
        uint256 amountToReceive = _amounttoswap * daiPriceInbat / decimal;
        bool success = token1.approve(address(this), _amounttoswap);
        bool deduct = token2.transferFrom(msg.sender, address(this), _amounttoswap);
        bool pay =  token1.transfer(msg.sender, amountToReceive);
        require(deduct, "Transfer of token1 failed");
        require(pay, "Transfer of token2 failed");
        require(success, "Approval of Bat failed");
        swapped = true;
    }

    receive() external payable{

    }

    fallback() external{

    }
   

}
