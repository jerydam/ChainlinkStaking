
import { ethers } from "hardhat";
import { BigNumber } from "ethers";
import { providers } from "ethers";

async function main() {

  const TOKENA_ADDRESS = "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d";
const TOKENB_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const USDHolder = "0x748dE14197922c4Ae258c7939C7739f3ff1db573"
const PRICE_FEED_ADDRESS = "0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9";
const AMOUNT = ethers.utils.parseEther("1");
console.log(AMOUNT);
  console.log("Deploying TokenSwap contract...");
  const TokenSwap = await ethers.getContractFactory("TokenSwap");
  const tokenSwap = await TokenSwap.deploy(TOKENA_ADDRESS, TOKENB_ADDRESS, PRICE_FEED_ADDRESS);
  await tokenSwap.deployed();

  console.log("TokenSwap contract deployed to:", tokenSwap.address);

  const token1 = await ethers.getContractAt("IERC20", TOKENA_ADDRESS);
  const token2 = await ethers.getContractAt("IERC20", TOKENB_ADDRESS);

const helpers = require("@nomicfoundation/hardhat-network-helpers");
await helpers.impersonateAccount(USDHolder);
const impersonatedSigner = await ethers.getSigner(USDHolder);
const USDContract = await ethers.getContractAt("IUSD", TOKENA_ADDRESS);
const DaiContract = await ethers.getContractAt("IUSD",TOKENA_ADDRESS);

const holderBalance = await USDContract.balanceOf(USDHolder);
console.log(`USD balance before ${holderBalance}`);
const getExchangeRate = await tokenSwap.connect(impersonatedSigner).getExchangeRate();
const SwapToken = await tokenSwap.connect(impersonatedSigner).swapTokens(
  AMOUNT,

)
}
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
