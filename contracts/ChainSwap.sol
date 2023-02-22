// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract TokenSwap {
    using SafeERC20 for IERC20;
    AggregatorV3Interface internal priceFeed;

    address public tokenA;
    address public tokenB;

    constructor(address _tokenA, address _tokenB, address _priceFeed) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getExchangeRate() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function swapTokens(uint256 amount) public {
        uint256 rate = getExchangeRate();

        uint256 amount2 = amount * rate;

        IERC20(tokenA).safeTransferFrom(msg.sender, address(this), amount);

        IERC20(tokenB).safeTransfer(msg.sender, amount2);
    }
}
